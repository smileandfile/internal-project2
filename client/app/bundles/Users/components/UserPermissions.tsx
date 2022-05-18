import {observer} from 'mobx-react';
import PropTypes from 'prop-types';
import * as React from 'react';

import { Dropdown, DropdownMenuItemType } from 'office-ui-fabric-react/lib/Dropdown';
import { DefaultButton, IButtonProps } from 'office-ui-fabric-react/lib/Button';
import { MessageBar, MessageBarType } from 'office-ui-fabric-react/lib/MessageBar';
import { Checkbox } from 'office-ui-fabric-react/lib/Checkbox';
import { RoleTreeList } from './RoleTreeList';
import * as EntityRow from './EntityAndGstinSelectionRow';
import { IUserPermissionStore, ISelectionOptionsStore, ICheckableItem, IEntitySelectionItem, User } from './interfaces';

function performFetch(url, authHeaders, options) {
  return fetch(url, Object.assign(options, {
    headers: new Headers(Object.assign({
      'Content-Length': options.body.length,
      'Content-Type': 'application/json'
    }, authHeaders))
  }));
}

interface IUserAppProps {
  permissions: IUserPermissionStore,
  selection: ISelectionOptionsStore,
  authHeaders: any
}

@observer
export class UserPermissions extends React.Component<IUserAppProps, {}> {

  _railsContext: any;

  _authHeaders: { [key: string]: string };

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props: IUserAppProps, _railsContext) {
    super(props);
    this._railsContext = _railsContext;
    this._authHeaders = props.authHeaders;
  }

  showEntity = (data: ICheckableItem) => {
    console.log('showEntity', data);
    const {permissions} = this.props;
    permissions.selectedUser = data as User;
  }

  handleEntityUpdate = (entity, data: IEntitySelectionItem) => {
    const { entitiesSelectedByUsers, selectedUser } = this.props.permissions;
    entitiesSelectedByUsers[selectedUser.key] = entitiesSelectedByUsers[selectedUser.key] || {};
    const entitiesForThisUser = entitiesSelectedByUsers[selectedUser.key];
    entitiesForThisUser[entity.key] = data;
  }

  submitForm = () => {
    const { selectedUser, entitiesSelectedByUsers, selectedRoleIdsByUsers } = this.props.permissions;
    const userId = selectedUser.key;
    const entitiesSelected = entitiesSelectedByUsers[userId];
    const entityIds = Object.keys(entitiesSelected).filter(i => entitiesSelected[i].selected);
    const gstinIds = entityIds.reduce((acc: Set<string>, id) => {
      const gstinsSelected: Set<string> = entitiesSelected[id].gstins;
      gstinsSelected.forEach(i => acc.add(i));
      return acc;
    }, new Set<string>());

    console.log(this._authHeaders);
    const body = JSON.stringify({
      user: {
        entity_ids: entityIds,
        gstin_ids: Array.from(gstinIds),
        role_ids: Array.from(selectedRoleIdsByUsers[userId] || [])
      }
    });
    this.props.permissions.saveInProgress = true;
    performFetch(`/api/domains/${selectedUser.domain_id}/users/${userId}`, this._authHeaders, {
      method: 'put',
      body
    }).then(response => {
      this.props.permissions.saveInProgress = false;
      console.log(response);
    }).catch(reason => {
      this.props.permissions.saveInProgress = false;
      console.log(reason);
    })
  }

  get allEntitiesSelected() {
    const currentEntities = this.currentUserSelectedEntities;
    return Object.keys(currentEntities)
          .filter(key => currentEntities[key].selected)
          .length == this.props.selection.entities.length;
  }

  handleSelectAllEntities = () => {
    const allEntities = this.props.selection.entities;
    const currentEntities = this.currentUserSelectedEntities;
    const newSelectedValue = !this.allEntitiesSelected;
    allEntities.forEach(entity => {
      currentEntities[entity.key] = currentEntities[entity.key] || {selected: newSelectedValue, gstins: new Set()};
      currentEntities[entity.key].selected = newSelectedValue;
    });
  }

  get allGstinsSelected() {
    const currentEntities = this.currentUserSelectedEntities;
    const gstinIds = Object.keys(currentEntities)
        .reduce((acc, i) => acc.concat(Array.from(currentEntities[i].gstins)), []);
    return new Set(gstinIds).size == this.props.selection.gstins.length;
  }

  handleSelectAllGstins = () => {
    const currentEntities = this.currentUserSelectedEntities;
    if (this.allGstinsSelected) {
      Object.keys(currentEntities).forEach(i => {
        currentEntities[i].gstins = new Set();
      });
    } else {
      const gstinsByEntities = this.props.selection.gstinsByEntities;
      Object.keys(gstinsByEntities).forEach(i => {
        currentEntities[i].gstins = new Set(gstinsByEntities[i].map(j => j.key));
      });
    }
  }

  get currentUserSelectedEntities() {
    const {entitiesSelectedByUsers, selectedUser} = this.props.permissions;
    return entitiesSelectedByUsers[selectedUser.key];
  }

  render() {
    let {
      selectedUser, entitiesSelectedByUsers, saveInProgress, selectedRoleIdsByUsers
    } = this.props.permissions;
    let {
      users, entities, gstinsByEntities
    } = this.props.selection;

    let roles = this.props.selection.roles;

    return (
      <div className=''>
        <Dropdown
          placeHolder='Select a User'
          label='Please Select a User'
          id='Basicdrop1'
          ariaLabel='Basic dropdown example'
          options={users}
          onChanged={this.showEntity}
        />
        {selectedUser && <div className="row">
          <div className="col-xs-6 col-sm-6">
            <h2>Entity</h2>
            <Checkbox
              label="Select All"
              checked={this.allEntitiesSelected}
              onChange={this.handleSelectAllEntities}
            />
          </div>
          <div className="col-xs-6 col-sm-6">
            <h2>GSTIN</h2>
            <Checkbox
              label="Select All"
              checked={this.allGstinsSelected}
              onChange={this.handleSelectAllGstins}
            />
          </div>
        </div>}
        {selectedUser && entities.map(entity =>
          <EntityRow.EntityAndGstinSelectionRow
            selectionModel={entitiesSelectedByUsers[selectedUser.key][entity.key]}
            gstinOptions={gstinsByEntities[entity.key]}
            entity={entity}
            handleUpdate={(data) => this.handleEntityUpdate(entity, data)}
            key={entity.key}
          />)
        }
        {selectedUser &&
          <div>
            <h2>Roles</h2>
            <RoleTreeList
              groupedItems={roles}
              selectedIds={selectedRoleIdsByUsers[selectedUser.key] || selectedUser.role_ids}
              onSelectionChange={(role_ids) => {
                selectedRoleIdsByUsers[selectedUser.key] = role_ids;
              }} />
          </div>}
        <div className="row">
          <div className="col-xs-12">
            <DefaultButton
              data-automation-id='submit'
              description='Save the permissions'
              text={saveInProgress ? 'Saving...' : 'Save permissions'}
              disabled={saveInProgress}
              onClick={this.submitForm}
            />
          </div>
        </div>
      </div>
    );
  }
}
