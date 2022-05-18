import PropTypes from 'prop-types';
import * as React from 'react';
import {ICheckableItem, User, IEntitySelectionItem} from './interfaces';

import {
  Checkbox,
  ICheckboxStyles
} from 'office-ui-fabric-react/lib/Checkbox';
import { observer } from "mobx-react";

export interface ICheckboxListProps {
  options: Array<ICheckableItem> ,
  handleChange: (data: ICheckableItem) => void,
  checkedKeys: Set<String>
}

export function CheckboxList({
    options = [],
    handleChange = (_) => {},
    checkedKeys = new Set()
  }: ICheckboxListProps) {
  return <div>
    {options.map(
      ({key, text}) => <Checkbox
          label={text}
          key={key}
          checked={checkedKeys.has(key)}
          onChange={() => handleChange({key, text})}
      />)}
  </div>
}

export interface IEntityAndGstinSelectionRowProps {
  selectionModel: IEntitySelectionItem,
  gstinOptions: Array<ICheckableItem>,
  entity: ICheckableItem,
  handleUpdate: (data: IEntitySelectionItem) => void
}

@observer
export class EntityAndGstinSelectionRow extends React.Component<IEntityAndGstinSelectionRowProps, {}> {
  constructor(props: IEntityAndGstinSelectionRowProps) {
    super(props);
  }

  render() {
    const {selectionModel, gstinOptions, entity} = this.props;

    return (
      <div className="row row-margins">
        <div className="col-xs-6 col-sm-6">
          <Checkbox
            label={entity.text}
            checked={selectionModel.selected}
            onChange={this.handleEntitySelection}
          />
        </div>
        <div className="col-xs-6 col-sm-6">
          <CheckboxList
              options={gstinOptions}
              handleChange={this.handleGstinSelection}
              checkedKeys={selectionModel.gstins}
          />
        </div>
      </div>
    );
  }

  handleGstinSelection = (item: ICheckableItem) => {
    const selected = this.props.selectionModel;
    const currentGstins = new Set(selected.gstins);
    const newValue: IEntitySelectionItem = {selected: selected.selected, gstins: currentGstins};
    currentGstins.has(item.key) ? currentGstins.delete(item.key) : currentGstins.add(item.key);
    if (currentGstins.size == this.props.gstinOptions.length) {
      newValue.selected = true
    }
    this.props.handleUpdate(newValue);
  }

  handleEntitySelection = () => {
    const {selectionModel, gstinOptions} = this.props;
    const newSelectedValue = !selectionModel.selected;
    const gstins = new Set(
      newSelectedValue ? this.props.gstinOptions.map(i => i.key) : []
    );

    this.props.handleUpdate({selected: newSelectedValue, gstins});
  }
}