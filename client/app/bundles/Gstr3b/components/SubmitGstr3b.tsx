import PropTypes from 'prop-types';
import * as React from 'react';
import * as update from 'immutability-helper';
import {
  Spinner,
  SpinnerSize
} from 'office-ui-fabric-react/lib/Spinner';


export default class SubmitGstr3b extends React.Component<any, any> {

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);
    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
    this.state = {
      auth_header: this.props.auth_header,
      gstin: this.props.gstin,
      set_gstin_url: this.props.set_gstin_url,
      gstr3b_submit_url: this.props.gstr3b_submit_url,
      return_period: '',
      gstr3b_response: {},
      loader: false
    };
  }
  
  handleSubmit = (event) => {
    const method = "POST";
    const hostname = this.state.gstr3b_submit_url;
    const body = new FormData(event.target);
    let gstr3b_response = {};
    this.setState({...this.state, loader: true});
    fetch(hostname, {
       method: 'POST',
       body: body,
       headers: {
          'access-token': this.state.auth_header['access-token'],
          'token-type': this.state.auth_header['token-type'],
          'expiry': this.state.auth_header['expiry'],
          'client': this.state.auth_header['client'],
          'uid': this.state.auth_header['uid'],
          'gstin-id': this.state.auth_header['gstin-id'],
          'domain-name': this.state.auth_header['domain-name']
        }})
      .then(res => res.json())
      . then(response => {
        this.setState({
            ...this.state,
            gstr3b_response: response,
            loader: false
        });
      })
    event.preventDefault();
  }  

  render() {
    return (
      <div>
        <a href={this.state.set_gstin_url} className='btn btn-default text-right'>Change GSTIN Number</a>
        <hr/>
        <p><strong>Gstin Number: </strong>{this.state.gstin.gstin_number}</p>
        <p><strong>GSP Username: </strong>{this.state.gstin.username}</p>
        <form onSubmit={this.handleSubmit} >
          <label>Return Period</label>
          <input type='text' name='data[return_period]' value={this.props.return_period} />
          <input type='hidden' name='return_period' value={this.state.return_period} />
          <label>GSTIN</label>
          <input type='text' name="data[gstin]" value={this.state.gstin.gstin_number} />
          <input type='submit' className='btn btn-default' value='Submit' />
        </form>
        Response:
        { this.state.loader && <Spinner size={ SpinnerSize.large } label='loading...' ariaLive='assertive' />}
        <pre>{JSON.stringify(this.state.gstr3b_response, undefined, 2)}</pre>
      </div>
    );
  }
}
