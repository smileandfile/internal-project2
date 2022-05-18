import {observable} from 'mobx';
import {observer} from 'mobx-react';
import * as React from 'react';

import {IUserPermissionStore, ISelectionOptionsStore} from './interfaces';
import {UserPermissions} from './UserPermissions';


export const UserPermissionStore = observable<IUserPermissionStore>({
  selectedUser: null,
  entitiesSelectedByUsers: {},
  saveInProgress: false,
  loadInProgress: false,
  selectedRoleIdsByUsers: {}
});

export const SelectionOptionsStore = observable<ISelectionOptionsStore>({
  users: [],
  gstins: [],
  gstinsByEntities: {},
  entities: [],
  roles: {}
})

interface IUserAppProps {
  users: Array<{id:Number, email:string, name:string, domain_id:string, gstin_ids:Array<Number>, entity_ids:Array<Number>, role_ids: Array<Number>}>,
  gstins_by_entities: { [key: string]: Array<{id: Number, gstin_number: string}> },
  entities: Array<{id: Number, company_name: string}>,
  auth_header: { [key: string]: string },
  roles: any
}

@observer
export class UserPermissionsApp extends React.Component<IUserAppProps, any> {

  _railsContext: any;

  _authHeaders: any;

  constructor(props: IUserAppProps, _railsContext) {
    super(props);
    this._railsContext = _railsContext;
    this._authHeaders = props.auth_header;

    const toStringMapper = (i) => '' + i;
    const entities = SelectionOptionsStore.entities = this.props.entities
          .map(({id, company_name}) => ({
            key: toStringMapper(id),
            text: company_name
          }));
    const users = SelectionOptionsStore.users = this.props.users
        .map(({id, email, name, gstin_ids, entity_ids, role_ids, ...rest}) => ({
          key: toStringMapper(id),
          text: `${name} ( ${email} )` ,
          gstin_ids: gstin_ids.map(toStringMapper),
          entity_ids: entity_ids.map(toStringMapper),
          role_ids: role_ids.map(toStringMapper),
          email, ...rest
        }));

    const gstinsByEntities = SelectionOptionsStore.gstinsByEntities = entities
        .reduce((acc, {key}) => {
          acc[key] = (props.gstins_by_entities[key] || [])
            .map(({id, gstin_number}) => ({key: '' + id, text: gstin_number}))
          return acc;
        }, {})

    SelectionOptionsStore.gstins = [].concat(...entities.map(i =>
      (props.gstins_by_entities[i.key] || []).map(i => '' + i.id)
    ));

    UserPermissionStore.entitiesSelectedByUsers = users.reduce((acc, {key, entity_ids, gstin_ids}) => {
      acc[key] = entities.reduce((acc, {key}) => {
        acc[key] = {selected: entity_ids.indexOf(key) >= 0, gstins: new Set(gstin_ids)}
        return acc;
      }, {});

      return acc;
    }, {});

    SelectionOptionsStore.roles = this.props.roles;

    UserPermissionStore.selectedRoleIdsByUsers = users.reduce((acc, user) => {
      acc[user.key] = user.role_ids;
      return acc;
    }, {});
  }
  render() {
    return (<UserPermissions permissions={UserPermissionStore} selection={SelectionOptionsStore} authHeaders={this._authHeaders}/>);
  }
};
