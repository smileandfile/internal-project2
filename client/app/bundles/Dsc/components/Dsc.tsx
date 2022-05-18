import PropTypes from 'prop-types';
import * as React from 'react';

export class Dsc extends React.Component<any, any> {

  private ws : any;
  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);
    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
    this.state = {
      errorMessage: '',
      hasErrorMessage: false,
      isSignatureSet: false,
      signature: '',
      data: {},
      panNumber: this.props.panNumber,
      unsignedData: this.props.unsignedData
    };

  }

  componentWillReceiveProps(nextProps) {
    // You don't have to do this check first, but it can help prevent an unneeded render
    if (nextProps.panNumber !== this.state.panNumber || nextProps.unsignedData !== this.state.unsignedData) {
      this.setState({
         ...this.state,
         unsignedData: nextProps.unsignedData,
         panNumber: nextProps.panNumber });
    }
  }

  handleData = (data) => {
    let result = JSON.parse(data);
    this.setState({
      ...this.state,
      socket_response: result.movement
    });
  }

  updateOnMessageData = (e) => {
    this.setState({
      ...this.state,
      errorMessage: e.data,
      hasErrorMessage: true
    })
  }

  handleOnMessagae = (e) => {
    if (e.data.indexOf("subProtocol") == -1) {
      this.updateOnMessageData(e.data);
    }
  }

  getWebSocket = (index = 0) => {
    const connPorts = ['1585', '2095', '2568', '2868', '4587'];

    if (index > connPorts.length -1) {
    return this.showErrorMessage("Server not available. Please Restart your server");
    }

    if (this.ws && this.ws.OPEN) {
      this.ws;
    }

    const socketUrl = `wss://localhost.aspone.in:${connPorts[index]}`;
    var ws = new WebSocket(socketUrl);
    this.ws = ws;
    ws.onerror = (e) => {
      this.getWebSocket(++index);
    }
    ws.onmessage = (e) => {
      this.handleOnMessagae(e);
    }
    ws.onopen = () => {
      this.ws = ws;
      this.showErrorMessage("Connection Opened");
    }
  }

  showErrorMessage = (errorMessage) => {
    this.setState({...this.state, errorMessage, hasErrorMessage: true});
  }

  componentWillMount() {
    this.getWebSocket();
  }

  callSignedData = () => {
    const msg = `action=sign
                 tobesigned=${this.state.unsignedData}
                 panNo=${this.state.panNumber}
                 signtype=1
                 expirycheck=true
                 issuername=
                 certclass=0
                 certtype=DSC
                 certdetails=
                 uniqueId=12345`;
    const ws = this.ws;
    ws.send(msg);
    ws.onerror = function (error) {
      this.showErrorMessage('Please check the server connection2: ' + error);
    };
    ws.onmessage = (e) => {
      if (e.data.indexOf("subProtocol") == -1) {

        if (e.data.length == 0 || e.data == "" || e.data == null) {

          // Not Signed, do not proceed.
         return this.updateOnMessageData(e);
        }
        else {

          var nullData = e.data.substring(0, 14);
          var errorData = e.data.substring(0, 4);

          if (e.data == "signing canceled" || e.data == "signing failed" || nullData == "signature= null" || errorData == "error") {
            // Not Signed, do not proceed.
            return this.updateOnMessageData(e);
          }
          else {

            var respData = e.data;
            // getting signature value

            var siglast = respData.indexOf("SerialNo");
            var signature = respData.substring(10, siglast).trim();
            this.props.onResponse && this.props.onResponse(signature);

            // getting serial no

            var serialfirst = respData.indexOf("SerialNo");
            var seriallast = respData.indexOf("CommonName");
            var serial = respData.substring(serialfirst + 9, seriallast);

            // getting comman name

            var commanfirst = respData.indexOf("CommonName");
            var commanlast = respData.indexOf("IssuerName");
            var comman = respData.substring(commanfirst + 11, commanlast);

            //getting cert class

            var certfirst = respData.indexOf("SigningTime");
            var certlast = respData.length;
            var cert = respData.substring(certfirst + 12, certlast);

            this.setState({
              ...this.state,
              data: {signature, serial, comman, cert},
              isSignatureSet: true
            });
          }
        }
      }

    };


  }

  render() {
    
    return (
      <div>
        <pre>
          PAN: {this.state.panNumber}
        </pre>
        <pre>
          DATA: {this.state.unsignedData}
        </pre>
        <button onClick={() => this.callSignedData()} className="btn btn-default">Sign</button>

        {this.state.hasErrorMessage &&
          <pre>{this.state.errorMessage}</pre>
        }
        {this.state.isSignatureSet &&
          <pre>{JSON.stringify(this.state.data, undefined, 2)}</pre>
        }

      </div>
    );
  }
}