import PropTypes from 'prop-types';
import * as React from 'react';
import * as update from 'immutability-helper';
import InterStateSupply from './InterStateSupply';
import { Dropdown, DropdownMenuItemType } from 'office-ui-fabric-react/lib/Dropdown';
import {
  Spinner,
  SpinnerSize
} from 'office-ui-fabric-react/lib/Spinner';
import $ from 'jquery';
import 'jquery-serializejson';

export default class Gstr3bForm extends React.Component<any, any> {

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
      inputs: {},
      state_codes: this.props.states,
      save_gstr3b_url: this.props.save_gstr3b_url,
      return_period: this.props.return_period,
      submitFormData: {},
      gstr3b_response: {},
      loader: false
    };
  
  }
  

  getInputId = ({sumValue, inputId}) => sumValue + '-' + inputId;

  updateInputValue = ({sumValue, inputId, value}) => {
    value = isNaN(value) || value == '' ? 0 : parseFloat(value)
    const {calculatedSum, inputs} = this.state;
    this.setState({
      ...this.state, 
      inputs: {
        ...this.state.inputs,
        [this.getInputId({sumValue, inputId})]: value
      }
    });
  }

  sumForValue(sumValue) {
    let acc = 0;
    Object.keys(this.state.inputs)
        .filter(k => k.indexOf(sumValue) == 0)
        .forEach((key) => { acc += this.state.inputs[key]})
    return acc;
  }

  serializeForm = () => {
      return $($('form')).serializeJSON();
  }


  handleSubmit = (event) => {
    event.preventDefault();
    const method = "POST";
    const body = new FormData();
    const submitFormData = $($('form')).serializeJSON();
    const responseData = submitFormData['gstr3b'];
    responseData['gstin'] = submitFormData['gstin'];
    this.setState({
      ...this.state,
      submitFormData: responseData,
      loader: true
      })
    const hostname = this.state.save_gstr3b_url;
    fetch(hostname, {
       method: 'POST',
       body: JSON.stringify({ data: responseData, return_period: this.props.return_period}),
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
      .then( response => {
        this.setState({
          ...this.state,
          gstr3b_response: response,
          loader: false
        })
      });
            
  }

  updateReturnPeriod = (event) => {
    const value = event.target.value;
    this.setState({
      ...this.state,
      return_period: value
    })
  }


  render() {
    const taxes = ['Integrated Tax', 'Central Tax', 'State/UT Tax', 'Cess'];

    let outwardTaxableSuppliesDet = ["osup_det_txval", "osup_det_iamt", "osup_det_camt", "osup_det_samt", "osup_det_csamt"];

    let outwardTaxableSuppliesZero = ["osup_zero_txval", "osup_zero_iamnt", "osup_nil_camt", "osup_nil_samt", "osup_nil_csamt"];
    let outwardTaxableSuppliesZeroRowVal = ["EXPORTS (Done without payment of Duty)", "Supplies to SEZ (Done without payment of Duty)", "Others (If any)"];

    let outwardTaxableSuppliesNil = ["osup_nil_txval", "osup_nil_iamnt", "osup_nil_camt", "osup_nil_samt", "osup_nil_csamt"];
    let outwardTaxableSuppliesNilRowVal = ["NIL Rated Supplies", "Exempt Supplies	"];

    let outwardTaxableSuppliesIsup = ["osup_isup_rev_txval", "osup_isup_rev_iamnt", "osup_isup_rev_camt", "osup_isup_rev_samt", "osup_isup_rev_csamt"];
    let outwardTaxableSuppliesIsupRowVal = ["Purchase from Unregistered Dealers attracting GST 0.25%", "Purchase from Unregistered Dealers attracting GST 3%",
                                            "Purchase from Unregistered Dealers attracting GST 5%", "Purchase from Unregistered Dealers attracting GST 12%",
                                            "Purchase from Unregistered Dealers attracting GST 18%", "Purchase from Unregistered Dealers attracting GST 28%",
                                            "Imports of Goods", "Imports of Services", "Others (If any)"];

    let outwardTaxableSuppliesNongst = ["osup_nongst_txval", "osup_nongst_iamnt", "osup_nongst_camt", "osup_nongst_samt", "osup_nongst_csamt"];

    let attractingGst = ["0.25", "3", "5", "12", "18", "28"];
    let taxType = ['txval', 'iamt', 'camt', 'samt', 'csamt'];
    const newTaxType = ['iamt', 'camt', 'samt', 'csamt'];
    const taxType2 = ['iamt', 'camt', 'samt', 'cess'];

    let itcAvl = [{ name: "Import of goods", hidden_value: 'IMPG'}, { name: "Import of services", hidden_value: "IMPS"}, { name: "Inward supplies liable to reverse charge (other than 1 & 2 above)", hidden_value : "ISRC" }
                  ,{ name: "Inward supplies from ISD", hidden_value: "ISD"}, { name: "All other ITC", hidden_value: "OTH" }]

    let itcRev = [{ name: "As per rules 42 & 43 of CGST Rules", hidden_value: 'RUL'}, { name: "Others", hidden_value: "OTH"}]
    let itcIneligible = [{ name: "As per section 17(5)", hidden_value: "RUL" }, { name: "Others", hidden_value: "OTH"}]
    const states = this.state.state_codes
      .map(({code, full_name}) => ({
        key: code,
        text: `${full_name} (${code})`
      }));

    return (
      <div>
        <hr />
        <a href={this.props.set_gstin_url} className='btn btn-default'>Change GSTIN</a>
        <form onSubmit={this.handleSubmit}>
        <table className='table table-striped table-bordered table-hover'>
          <thead>
            <tr>
              <th colSpan={6}>
                Template to be filled to file Form GSTR-3B
              </th>
            </tr>
          </thead>
          <tbody>
          <tr>
            <td>GSTIN</td>
            <td colSpan={2}><input type='text' name="gstin" value={this.state.gstin.gstin_number} /></td>
          </tr>
          <tr>
            <td> Legal name of the registered person </td>
            <td colSpan={2}><input type='text' name="legal_name" /></td>
          </tr>
          <tr>
            <td>Return Period</td>
            <td colSpan={2}><input name="return_period" type='text' value={this.state.return_period}/></td>
            <input type='hidden' name="gstr3b[ret_period]" value={this.state.return_period} placeholder="Ex. 072017"/>
          </tr>
          </tbody>
        </table>
          <table className="snf-table">
            <thead>
              <tr>
              <th colSpan={8}>
                3.1 Details of Outward Supplies and inward supplies liable to reverse charge
              </th>
              </tr>
              <tr>
                <th colSpan={2}>Nature of Supplies</th>
                <th>Total Taxable value</th>
                <th>Integrated Tax</th>
                <th>Central Tax</th>
                <th>State/UT Tax</th>
                <th>Cess</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td colSpan={2}>1</td>
                  <td>2</td>
                  <td>3</td>
                  <td>4</td>
                  <td>5</td>
                  <td>6</td>
                </tr>
                <tr>
                  <td colSpan={8}><strong>(a) Outward taxable supplies (other than zero rated, nil rated and exempted)</strong></td>
                </tr>
                <tr>
                  <td colSpan={8}><strong>Intra State Supply</strong></td>
                </tr>
                {attractingGst.map((g, gIndex) => (
                  <tr key={gIndex}>
                    <td colSpan={2}>Attracting GST {g}%</td>
                    {outwardTaxableSuppliesDet.map((row, rowIndex) => (
                      <td>
                        <input type="text" step="0.01"
                            onChange={e => this.updateInputValue({ sumValue: `det${taxType[rowIndex]}`, inputId: `intra${g}`, value: e.target.value })}
                            value={this.state.inputs[this.getInputId({sumValue: `det${taxType[rowIndex]}`, inputId: `intra${g}`})]} />
                      </td>
                    ))}
                  </tr>
                ))}
                <tr>
                  <td colSpan={8}><strong>Inter State Supply</strong></td>
                </tr>
                {attractingGst.map((g, gIndex) => (
                  <tr key={gIndex}>
                    <td colSpan={2}>Attracting GST {g}%</td>
                    {outwardTaxableSuppliesDet.map((row, rowIndex) => (
                      <td>
                        <input type="text"
                           onChange={e => this.updateInputValue({ sumValue: `det${taxType[rowIndex]}`, inputId: `inter${g}`, value: e.target.value })}
                           value={this.state.inputs[this.getInputId({sumValue: `det${taxType[rowIndex]}`, inputId: `inter${g}`})]} />
                      </td>
                    ))}
                  </tr>
                ))}
                <tr>
                  <td colSpan={2}>Category Total(a)</td>
                  {taxType.map((row, rowIndex) => (

                    <td><input type="text" name={`gstr3b[sup_details][osup_det][${row}]:number`} value={this.sumForValue(`det${taxType[rowIndex]}`)} /></td>

                  ))}
                </tr>
                <tr>
                  <td colSpan={8}><strong>(b) Outward taxable supplies (zero rated)</strong></td>
                </tr>
                {outwardTaxableSuppliesZeroRowVal.map((row, rowIndex) => (
                  <tr key={rowIndex}>
                    <td colSpan={2}>{row}</td>
                    {outwardTaxableSuppliesZero.map((zero, zeroRowIndex) => (
                      <td>
                        <input type="text"
                           onChange={e => this.updateInputValue({ sumValue: `zero${taxType[zeroRowIndex]}`, inputId: `${row}${zero}`, value: e.target.value })}
                           value={this.state.inputs[this.getInputId({sumValue: `zero${taxType[zeroRowIndex]}`, inputId: `${row}${zero}`})]} />
                      </td>
                    ))}

                  </tr>
                ))}
                <tr>
                  <td colSpan={2}>Category Total(b)</td>
                  {taxType.map((row, rowIndex) => (

                    <td><input type="text" name={`gstr3b[sup_details][osup_zero][${row}]:number`} value={this.sumForValue(`zero${taxType[rowIndex]}`)} /></td>

                  ))}
                </tr>

                <tr>
                  <td colSpan={8}><strong>(c) Other outward supplies (Nil rated, exempted)</strong></td>
                </tr>
                {outwardTaxableSuppliesNilRowVal.map((row, rowIndex) => (
                  <tr key={rowIndex}>
                    <td colSpan={2}>{row}</td>
                    {outwardTaxableSuppliesNil.map((nil, nilRowIndex) => (
                      <td>
                        <input type="text"
                           onChange={e => this.updateInputValue({ sumValue: `nil${taxType[nilRowIndex]}`, inputId: `${row}${nil}`, value: e.target.value })}
                           value={this.state.inputs[this.getInputId({sumValue: `nil${taxType[nilRowIndex]}`, inputId: `${row}${nil}`})]} />
                      </td>
                    ))}

                  </tr>
                ))}
                <tr>
                  <td colSpan={2}>Category Total(c)</td>
                  {taxType.map((row, rowIndex) => (

                    <td><input type="text" name={`gstr3b[sup_details][osup_nil_exmp][${row}]:number`} value={this.sumForValue(`nil${taxType[rowIndex]}`)} /></td>

                  ))}
                </tr>


                <tr>
                  <td colSpan={8}><strong>(d) Inward supplies (liable to reverse charge)</strong></td>
                </tr>
                {outwardTaxableSuppliesIsupRowVal.map((row, rowIndex) => (
                  <tr key={rowIndex}>
                    <td colSpan={2}>{row}</td>
                    {outwardTaxableSuppliesIsup.map((isup, isupRowIndex) => (
                      <td>
                        <input type="text"
                           onChange={e => this.updateInputValue({ sumValue: `isup${taxType[isupRowIndex]}`, inputId: `${row}${isup}`, value: e.target.value })}
                           value={this.state.inputs[this.getInputId({sumValue: `isup${taxType[isupRowIndex]}`, inputId: `${row}${isup}`})]} />
                      </td>
                    ))}

                  </tr>
                ))}
                <tr>
                  <td colSpan={2}>Category Total(d)</td>
                  {taxType.map((row, rowIndex) => (
                    <td><input type="text" name={`gstr3b[sup_details][isup_rev][${row}]:number`} value={this.sumForValue(`isup${taxType[rowIndex]}`)} /></td>
                  ))}
                </tr>

                <tr>
                  <td colSpan={8}><strong>(e) Non-GST outward supplies</strong></td>
                </tr>
                  <tr>
                    <td colSpan={2}>All Supplies (other than (a) to (d)) above</td>
                    {outwardTaxableSuppliesIsup.map((isup, isupRowIndex) => (
                      <td>
                        <input type="text"
                           onChange={e => this.updateInputValue({ sumValue: `nongst${taxType[isupRowIndex]}`, inputId: `allsupplies${isup}`, value: e.target.value })}
                           value={this.state.inputs[this.getInputId({sumValue: `nongst${taxType[isupRowIndex]}`, inputId: `allsupplies${isup}`})]} />
                      </td>
                    ))}

                  </tr>
                <tr>
                  <td colSpan={2}>Category Total(e)</td>
                  {taxType.map((row, rowIndex) => (
                    <td><input type="text" name={`gstr3b[sup_details][osup_nongst][${row}]:number`} value={this.sumForValue(`nongst${taxType[rowIndex]}`)} /></td>
                  ))}
                </tr>

                <tr>
                  <td colSpan={2}>Category Total(a+b+c+d+e)</td>
                  {taxType.map((row, rowIndex) => {
                    const total = this.sumForValue(`nongst${taxType[rowIndex]}`) + this.sumForValue(`isup${taxType[rowIndex]}`) + this.sumForValue(`nil${taxType[rowIndex]}`)
                                  + this.sumForValue(`zero${taxType[rowIndex]}`) + this.sumForValue(`det${taxType[rowIndex]}`)
                    return (
                      <td><input type="text" value={total} /></td>
                    );
                    }
                  )}
                </tr>

            </tbody>
          </table>
          
          <hr />

          <table className="snf-table">
            <thead>
              <tr>
                <th colSpan={8}>
                  3.2 Of the supplies shown in 3.1 (a) above, details of inter-State supplies made to unregistered persons, composition taxable persons and UIN holders
                </th>
              </tr>
              <tr>
                <th colSpan={2}>Place of Supply(State/UT)</th>
                <th>Total Taxable value</th>
                <th>Amount Integrated Tax</th>
                <th></th>
              </tr>
            </thead>
            <InterStateSupply supInterns={this.state.sup_inters} states={this.state.state_codes} supply_name='unreg_details' supply_name_value="Unregistered Persons" />
            <InterStateSupply supInterns={this.state.sup_inters} states={this.state.state_codes} supply_name='comp_details' supply_name_value="Company Details" />
            <InterStateSupply supInterns={this.state.sup_inters} states={this.state.state_codes} supply_name='uin_details' supply_name_value="UIN holders" />
          </table>
          <hr/>
          <table className="snf-table">
            <thead>
              <tr>
                <td colSpan={8}>4. Eligible ITC</td>
              </tr>
              <tr>
                <td>Details</td>
                <td>Integrated Tax</td>
                <td>Central Tax</td>
                <td>State/UT Tax</td>
                <td>Cess</td>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td colSpan={8}>(A) ITC Available (whether in full or part)</td>
              </tr>
              
              {itcAvl.map((row, rowIndex) => (
                <tr key={rowIndex}>
                  <td>{row.name}</td>
                  <input type='hidden' name="gstr3b[itc_elg][itc_avl][][ty]" value={row.hidden_value} />
                  {newTaxType.map((type, index) =>(
                    <td>
                       <input type='text' name={`gstr3b[itc_elg][itc_avl][][${type}]:number`} 
                         onChange={e => this.updateInputValue({ sumValue: `itc_avl${type}`, inputId: `itc${row.name}${type}`, value: e.target.value })}
                          value={this.state.inputs[this.getInputId({sumValue: `itc_avl${type}`, inputId: `itc${row.name}${type}`})]} defaultValue="0" />
                    </td>

                  ))}
                </tr>
              ))}
              <tr>
                <td>Category Total(a)</td>
                {newTaxType.map((row, rowIndex) => (
                  <td><input type="text" value={this.sumForValue(`itc_avl${row}`)} defaultValue="0" /></td>
                ))}
              </tr>

              <tr>
                <td colSpan={8}>(B) ITC Reversed</td>
              </tr>
              
              {itcRev.map((row, rowIndex) => (
                <tr key={rowIndex}>
                  <td>{row.name}</td>
                  <input type='hidden' name="gstr3b[itc_elg][itc_rev][][ty]" value={row.hidden_value} />
                  {newTaxType.map((type, index) =>(
                    <td>
                       <input type='text' name={`gstr3b[itc_elg][itc_rev][][${type}]:number`} 
                         onChange={e => this.updateInputValue({ sumValue: `itc_rev${type}`, inputId: `itc${row.name}${type}`, value: e.target.value })}
                          value={this.state.inputs[this.getInputId({sumValue: `itc_rev${type}`, inputId: `itc${row.name}${type}`})]} defaultValue="0" />
                    </td>

                  ))}
                </tr>
              ))}
              <tr>
                <td>Category Total(b)</td>
                {newTaxType.map((row, rowIndex) => (
                  <td><input type="text" value={this.sumForValue(`itc_rev${row}`)} defaultValue="0" /></td>
                ))}
              </tr>
              <tr>
                <td>(C) Net ITC Available (A) – (B)</td>
                {newTaxType.map((row, rowIndex) => {
                  const netValue = (this.sumForValue(`itc_avl${row}`) - this.sumForValue(`itc_rev${row}`));
                  return (
                    <td><input type="text" value={netValue} name = {`gstr3b[itc_elg][itc_net][${row}]:number`} defaultValue="0" /></td>
                  );
                })}
              </tr>
            </tbody>
          </table>
          <hr />

          <table className="snf-table">
            <thead>
              <tr>
                <th colSpan={6}>
                  5. Values of exempt, nil-rated and non-GST  inward supplies
                </th>
              </tr>
              <tr>
                <th>Nature of supplies</th>
                <th>Inter-State supplies</th>
                <th>Intra-State supplies</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>1</td>
                <td>2</td>
                <td>3</td>
              </tr>
              <tr>
                <td>From a supplier under composition scheme, Exempt and Nil rated supply</td>
                <input type='hidden' name="gstr3b[inward_sup][isup_details][][ty]" value="GST" />
                <td><input type='text' name="gstr3b[inward_sup][isup_details][][inter]:number" defaultValue="0" /></td>
                  <td><input type='text' name="gstr3b[inward_sup][isup_details][][intra]:number" defaultValue="0" /></td>
              </tr>
              <tr>
                <td>Non GST supply</td>
                  <input type='hidden' name="gstr3b[inward_sup][isup_details][][ty]" value="NONGST" />
                <td><input type='text' name="gstr3b[inward_sup][isup_details][][inter]:number" defaultValue="0" /></td>
                <td><input type='text' name="gstr3b[inward_sup][isup_details][][intra]:number" defaultValue="0" /></td>
              </tr>
            </tbody>
          </table>
          <hr />
          <table className='snf-table'>
            <thead>
              <tr>
                <th colSpan={2}>Payment of tax (Late Fee)</th>
              </tr>
              <tr>
                <th>Description</th>
                <th>Interest</th>
              </tr>
            </thead>
            <tbody>
              {taxes.map((row, index) => (
                <tr key={index}>
                  <td>{row}</td>
                  <td><input type='text' name={`gstr3b[intr_ltfee][intr_details][${newTaxType[index]}]:number`} defaultValue="0"/></td>
                </tr>
              ))}
            </tbody>
          </table>
          <hr />
         <input type="submit" value="Submit" className='btn btn-default'/>
        </form>
        <h3>Request Payload</h3>
        <pre>{JSON.stringify(this.state.submitFormData, undefined, 2)}</pre>
        <h3>Response Payload</h3>
        { this.state.loader && <Spinner size={ SpinnerSize.large } label='loading...' ariaLive='assertive' />}
        <pre>{JSON.stringify(this.state.gstr3b_response, undefined, 2)}</pre>
      </div>
    );
  }
}
