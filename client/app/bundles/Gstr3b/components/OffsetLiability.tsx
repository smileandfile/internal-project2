import PropTypes from 'prop-types';
import * as React from 'react';
import { Dropdown, DropdownMenuItemType } from 'office-ui-fabric-react/lib/Dropdown';
import { TextField } from 'office-ui-fabric-react/lib/TextField';
import * as update from 'immutability-helper';
import { Modal } from 'office-ui-fabric-react/lib/Modal';
import { PrimaryButton, DefaultButton } from 'office-ui-fabric-react/lib/Button';
import { ChoiceGroup } from 'office-ui-fabric-react/lib/ChoiceGroup';
import {
  Spinner,
  SpinnerSize
} from 'office-ui-fabric-react/lib/Spinner';
import $ from 'jquery';
import 'jquery-serializejson';

export default class GetGstr3bDetails extends React.Component<any, any> {

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
      gstr3b_offset_url: this.props.gstr3b_offset_url,
      gstr3b_response: {},
      gstr3b_request: {},
      loader: false
    };
  }
  
  handleSubmit = (event) => {
    const method = "POST";
    const hostname = this.state.gstr3b_offset_url;
    const body = new FormData();
    let gstr3b_response = {};
    const submitFormData = $($('form')).serializeJSON();
    let newRequestData = {};
    newRequestData['pditc'] = submitFormData['gstr3b']['pditc'];
    newRequestData['pdcash'] = [];
    newRequestData['pdcash'].push(submitFormData['gstr3b']['pdcash'][0]);
    newRequestData['pdcash'].push(submitFormData['gstr3b']['pdcash'][1]);
    this.setState({
      ...this.state,
      gstr3b_request: newRequestData
    })
    for ( var key in newRequestData ) {
      body.append(key, JSON.stringify(newRequestData[key]));
    }
    fetch(hostname, {
       method: 'POST',
       body: JSON.stringify({data: newRequestData, return_period: this.props.return_period }),
       headers: {
          'access-token': this.state.auth_header['access-token'],
          'token-type': this.state.auth_header['token-type'],
          'expiry': this.state.auth_header['expiry'],
          'client': this.state.auth_header['client'],
          'uid': this.state.auth_header['uid'],
          'gstin-id': this.state.auth_header['gstin-id'],
          'domain-name': this.state.auth_header['domain-name'],
          'Content-type': 'application/json'
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
    const taxes = ['Integrated Tax', 'Central Tax', 'State/UT Tax', 'Cess'];
    return (
      <div  className='table-responsive'>
        <a href={this.state.set_gstin_url} className='btn btn-default text-right'>Change GSTIN Number</a>
        <hr/>
        <form onSubmit={this.handleSubmit} >
          <div className="panel panel-default">
            <div className="panel-body">
              Paid Through ITC
            </div>
            <div className="panel-footer">
              <span>
                Liability Ledger Id:&nbsp;
                <input type='text' name='gstr3b[pditc][liab_ldg_id]:number' />
              </span>
              <span className="pull-right">
                Transaction Type:&nbsp;
                <input type='text' name='gstr3b[pditc][trans_typ]:number' />
              </span>
            </div>
          </div> 
          <div className="panel panel-default">
            <div className="panel-body">
              Paid Through Cash
            </div>
            <div className="panel-footer">
              Liability Ledger Id:&nbsp; 
              <input type='text' name='gstr3b[pdcash][1][liab_ldg_id]:number' />
              <span className="pull-right">
                Transaction Type: 
                <input type='text' name='gstr3b[pdcash][1][trans_typ]:number' />
              </span>
            </div>
          </div> 
          <div className="panel panel-default">
            <div className="panel-body">
              Paid Through Cash(Interest & late fee)
            </div>
            <div className="panel-footer">
              Liability Ledger Id:&nbsp;
              <input type='text' name='gstr3b[pdcash][0][liab_ldg_id]:number' />
              <span className="pull-right">
                Transaction Type:&nbsp;
                <input type='text' name='gstr3b[pdcash][0][trans_typ]:number' />
              </span>
            </div>
          </div> 
         <input type="hidden" name="return_period" value={this.props.return_period} /> 
         <table className="snf-table">
            <thead>
                <tr>
                  <th>Description</th>
                  <th>Tax Payable</th>
                  <th>
                    Integrated Tax(Paid through ITC)
                  </th>
                  <th>
                    Central Tax(Paid through ITC)
                  </th>
                  <th>
                    State/UT Tax(Paid through ITC)
                  </th>
                  <th>
                    Cess(Paid through ITC)
                  </th>
                  <th>Tax Paid TDS/TCS</th>
                  <th>Tax/Cess(Paid in cash)</th>
                  <th>Interest</th>
                  <th>Late Fee</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                  <td>Integrated Tax</td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pditc][i_pdi]:number" /></td>
                  <td><input type="text" name="gstr3b[pditc][i_pdc]:number"/></td>
                  <td><input type="text" name="gstr3b[pditc][i_pds]:number"/></td>
                  <td><input type="text" disabled/></td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pdcash][0][ipd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][i_intrpd]:number"/></td>
                  <td><input type="text" name="gstr3b[pdcash][1][i_lfeepd]:number" /></td>
                </tr>
                <tr>
                  <td>Central Tax</td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pditc][c_pdi]:number"/></td>
                  <td><input type="text" name="gstr3b[pditc][c_pdc]:number" /></td>
                  <td><input type="text" disabled/></td>
                  <td><input type="text" disabled/></td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pdcash][0][cpd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][c_intrpd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][c_lfeepd]:number" /></td>
                </tr>
                <tr>
                  <td>State/UT Tax</td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pditc][s_pdi]:number" /></td>
                  <td><input type="text" disabled/></td>
                  <td><input type="text" name="gstr3b[pditc][s_pds]:number" /></td>
                  <td><input type="text" disabled/></td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pdcash][0][spd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][s_intrpd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][s_lfeepd]:number" /></td>
                </tr>
                <tr>
                  <td>Cess</td>
                  <td></td>
                  <td><input type="text" disabled/></td>
                  <td><input type="text" disabled/></td>
                  <td><input type="text" disabled/></td>
                  <td><input type="text" name="gstr3b[pditc][cs_pdcs]:number" /></td>
                  <td></td>
                  <td><input type="text" name="gstr3b[pdcash][0][cspd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][cs_intrpd]:number" /></td>
                  <td><input type="text" name="gstr3b[pdcash][1][cs_lfeepd]:number" /></td>
                </tr>
            </tbody>
          </table>
          <input type="submit" className="btn btn-default" />
        </form>
        Request Payload
        <pre>{JSON.stringify(this.state.gstr3b_request, undefined, 2)}</pre>
        { this.state.loader && <Spinner size={ SpinnerSize.large } label='loading...' ariaLive='assertive' />}
        <pre>{JSON.stringify(this.state.gstr3b_response, undefined, 2)}</pre>
      </div>
    );
    
  }
}
