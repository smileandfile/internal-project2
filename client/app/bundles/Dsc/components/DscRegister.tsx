import PropTypes from 'prop-types';
import * as React from 'react';
import {Dsc} from './Dsc';
import { Dropdown, DropdownMenuItemType } from 'office-ui-fabric-react/lib/Dropdown';
var hash = require('hash.js');

export default class DscRegister extends React.Component<any, any> {

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);
    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
    this.state = {
      response: "",
      isResponseSet: false,
      panNumber: '',
      unsignedData: "",
      register_dsc_url: this.props.register_dsc_url,
      deregister_dsc_url: this.props.deregister_dsc_url,
      auth_header: this.props.auth_header,
      dsc_response: {},
      gstins: this.props.gstins,
      selectedGstin: 0
    };
  }

  DscRequest = (register = false) => {
    if(this.state.selectedGstin <= 0) {
      return alert("Please select gstin")
    }
    const method = "POST";
    const hostname = register ?  this.state.register_dsc_url : this.state.deregister_dsc_url
    const body = new FormData();
    const items = {
      data: this.state.panNumber,
      sign: this.state.response
    }
    for ( var key in items ) {
        body.append(key, items[key]);
    }
    fetch(hostname, {
       method: 'POST',
       body: body,
       headers: {
          'access-token': this.state.auth_header['access-token'],
          'token-type': this.state.auth_header['token-type'],
          'expiry': this.state.auth_header['expiry'],
          'client': this.state.auth_header['client'],
          'uid': this.state.auth_header['uid'],
          'gstin-id': this.state.selectedGstin,
          'domain-name': this.state.auth_header['domain-name']
        }})
      .then(res => res.json())
      . then(response => {
        this.setState({
            ...this.state,
            dsc_response: response
        });
      })
    event.preventDefault();
  }

  getUnsignedData = () => {
    return this.state.panNumber!= "" ?  hash.sha256().update(this.state.panNumber).digest('hex') : ""
  }
  
  render() {
    const gstins = this.props.gstins;

    return (
      <div>
        STEPS: 
        <p> 1. Sign your pan number </p>
        <p>2. Select GSTIN from dropdown</p>
        <p>2. Click on Register DSC Button</p>
        <Dropdown
            label='Select Gstin'
            options={gstins}
            onChanged={(e) => this.setState({...this.state, selectedGstin: e.key})}
        />

        <label>PAN Number </label>
        <input type='text' onChange={(e) => this.setState({...this.state, panNumber: e.target.value })} />
        <Dsc unsignedData={this.getUnsignedData()} panNumber={this.state.panNumber} onResponse={(data) => this.setState({...this.state, response: data, isResponseSet: true})} />
        Sign Response:
        <pre>{ this.state.isResponseSet && this.state.response}</pre>
        <button onClick={ () => this.DscRequest(true) } className='btn btn-default'>Register</button>
        <br />
        DSC RESPONSE: 
        <pre>{JSON.stringify(this.state.dsc_response, undefined, 2)}</pre>
      </div>
    );
  }
}
