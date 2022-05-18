import PropTypes from 'prop-types';
import * as React from 'react';
import {
  Spinner,
  SpinnerSize
} from 'office-ui-fabric-react/lib/Spinner';
import { TextField } from 'office-ui-fabric-react/lib/TextField';
import * as update from 'immutability-helper';

export default class SearchTaxPayer extends React.Component<any, any> {

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);
    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes

    this.state = {
      gstinToData: {},
      auth_header: this.props.auth_header,
      loader: false
    };
  }

  searchGstins = (gstin) => {
    const method = "POST";
    const hostname = this.props.search_tax_payer_url;
    this.setState({...this.state, loader: true});
    event.preventDefault();
    return fetch(hostname, {
       method: 'POST',
       body: JSON.stringify({gstin: gstin }),
       headers: {
          'access-token': this.state.auth_header['access-token'],
          'token-type': this.state.auth_header['token-type'],
          'expiry': this.state.auth_header['expiry'],
          'client': this.state.auth_header['client'],
          'uid': this.state.auth_header['uid'],
          'domain-name': this.state.auth_header['domain-name'],
          'Content-type': 'application/json'
        }})
  }

  searchMultipleGstins = (data) => {
    data.currentTarget.value
        .split('\n')
        .filter(Boolean)
        .map(i => i.trim())
        .forEach((gstin, index) => {
          var gstinData = {}
          gstinData[gstin] = {
            loading: true,
            data: {},
            error: ""
          }
          this.setState(update(this.state, {gstinToData: {$merge: gstinData}})); 
          this.searchGstins(gstin)
              .then(res => res.json())
              .then(response => {
                if (response.status_cd == "0") {
                  this.setState(update(this.state, {gstinToData: {$merge: { [gstin]: {data: null, error: response.error.message, loading: false} }}}))
                } else {
                  this.setState(update(this.state, {gstinToData: {$merge: { [gstin]: {data: response, error: null, loading: false} }}}))
                }
                
              })
        })
  }
  
  render() {
    const gstinToData =  this.state.gstinToData;
    return (
      <div>
        <TextField
          label='Search Multiple GSTINS'
          multiline
          rows={ 4 }
          onBlur={ (data) => this.searchMultipleGstins(data)}
        /> 
        Response:
         <table className='table table-striped table-bordered table-hover'>
           <thead>
             <tr>
               <th>GSTIN</th>
               <th>Response</th>
             </tr>
            </thead>
            <tbody>
              {Object.keys(gstinToData).map(gstin => (
                <tr>
                  <td>{gstin}</td>
                  {gstinToData[gstin].loading ? <td colSpan={5}>{ <Spinner size={ SpinnerSize.large } label='loading...' ariaLive='assertive' />}</td> : <td colSpan={5}>{JSON.stringify(gstinToData[gstin], undefined, 2)}</td>}
                </tr>
              ))}
            </tbody>
        </table> 
      </div>
    );
  }
}
