import * as React from 'react';
import {
  GroupedList,
  IGroup
} from 'office-ui-fabric-react/lib/components/GroupedList/index';
import { IColumn } from 'office-ui-fabric-react/lib/DetailsList';
import { DetailsRow } from 'office-ui-fabric-react/lib/components/DetailsList/DetailsRow';
import {
  FocusZone
} from 'office-ui-fabric-react/lib/FocusZone';
import {
  Selection,
  SelectionMode,
  SelectionZone
} from 'office-ui-fabric-react/lib/utilities/selection/index';
import { observer } from "mobx-react";

export interface IRoleTreeListProps {
  groupedItems: {[key: string]: {id: number, name: string}[] },
  selectedIds: string[],
  onSelectionChange: (any: any) => void
}

@observer
export class RoleTreeList extends React.Component<IRoleTreeListProps, any> {
  private _selection: Selection;
  private _items: any[];
  private _groups: IGroup[];

  constructor(props) {
    super(props);
    let {groupedItems} = this.props;

    this._onRenderCell = this._onRenderCell.bind(this);
    this._items = Object.keys(groupedItems)
        .reduce((acc, item) => acc.concat(Array.from(groupedItems[item])), [])
        .map(({id, ...rest}) => ({id: '' + id, key: '' + id, ...rest}));
    let index = 0;
    // parentId is null for top level roles
    this._groups = groupedItems[''].map(({id, name}) => {
      let key = '' + id;
      let startIndex = index;
      let count = (groupedItems[key] || []).length;
      index += count
      return {
        count, key, name, startIndex
      };
    });
    this._selection = new Selection({
      onSelectionChanged: () => {
        this.props.onSelectionChange(this._selection.getSelection().map((i:any) => i.id))
      }
    });
    this._selection.setItems(this._items);
    this._selection.setChangeEvents(false);
    this.props.selectedIds.forEach(id => {
      this._selection.setKeySelected(id, true, false);
    });
    this._selection.setChangeEvents(true, true);
  }

  public render() {
    return (
      <FocusZone>
        <SelectionZone
          selectionPreservedOnEmptyClick={true}
          selection={ this._selection }
          selectionMode={ SelectionMode.multiple }
        >
          <GroupedList
            items={ this._items }
            onRenderCell={ this._onRenderCell }
            selection={ this._selection }
            selectionMode={ SelectionMode.multiple }
            groups={ this._groups }
          />
        </SelectionZone>
      </FocusZone>
    );
  }

  private _onRenderCell(nestingDepth: number, item: any, itemIndex: number) {
    let {
      _selection: selection
    } = this;
    return (
      <DetailsRow
        columns={
          [{
            key: 'role',
            name: 'Role',
            fieldName: 'name',
            minWidth: 300
          }]
        }
        groupNestingDepth={ nestingDepth }
        item={ item }
        itemIndex={ itemIndex }
        selection={ selection }
        selectionMode={ SelectionMode.multiple }
      />
    );
  }
}