import PropTypes from 'prop-types';
import { Dropdown, DropdownMenuItemType } from 'office-ui-fabric-react/lib/Dropdown';
import * as update from 'immutability-helper';
import * as React from 'react';
import Select from 'react-select';





export default class InterStateSupply extends React.Component<any, any> {

  constructor(props) {
    super(props);
    this.state = {
      state_codes: this.props.states,
      supply_name: this.props.supply_name,
      supply_name_value: this.props.supply_name_value,
      sup_inters: []
    }
  }

  handleRowDel = (row) => {
    var index = this.state.sup_inters.indexOf(row); 
    this.setState(update(this.state, {sup_inters: {$splice: [[index, 1]]}}));
  };

  handleAddEventSupIntern(evt) {
    var sup_inter = {
      pos: 0,
      txval: 0,
      iamt: 0
    }
    this.setState(update(this.state, {sup_inters: {$push: [sup_inter]}})); 
  }

  render() { 
    const states = this.state.state_codes
      .map(({code, full_name}) => ({
        value: code,
        label: `${full_name} (${code})`
      }));

    const supplyName = this.state.supply_name;
    const supplyNameValue = this.state.supply_name_value;

    return (
      <tbody>
        <tr>
          <td colSpan={8}>
            <strong>Supplies made to {supplyNameValue}</strong>
            <button type="button" onClick={this.handleAddEventSupIntern.bind(this)} className="btn btn-default pull-right">Add Row To {supplyNameValue} </button>
          </td>
        </tr>
        {this.state.sup_inters.map((row, rowIndex) => (
          <tr>
            <td></td>
            <td>
            <Select
              name="form-field-name"
              value={row.pos}
              options={states}
              onChange={(e) => this.setState(update(this.state, {sup_inters: { [rowIndex]: {pos: {$set: e['value']}} }}))}
            />
            </td>
            <input type='hidden' name={`gstr3b[inter_sup][${supplyName}][][pos]`} value={row.pos} defaultValue={row.pos} />
            <td><input type='text' name={`gstr3b[inter_sup][${supplyName}][][txval]:number`} defaultValue={row.txavl} /></td>
            <td><input type='text' name={`gstr3b[inter_sup][${supplyName}][][iamt]:number`} defaultValue={row.iamt} /></td>
            <td className="del-cell">
              <button onClick={() => this.handleRowDel(row)} className='btn btn-default'>delete</button>
            </td>
          </tr>
        ))}

      </tbody>


    );

  }
}