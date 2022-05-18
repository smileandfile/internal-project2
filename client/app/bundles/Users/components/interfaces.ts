
export interface ICheckableItem {
  key: string,
  text: string
}

export interface User extends ICheckableItem {
  domain_id: string,
  gstin_ids: string[],
  entity_ids: string[],
  role_ids: string[]
}

export interface IEntitySelectionItem {
  selected: boolean,
  gstins: Set<string>
}

export interface IUserPermissionStore {
  selectedUser?: ICheckableItem & User,
  entitiesSelectedByUsers: { [key: string]: { [key: string]: IEntitySelectionItem }},
  saveInProgress: boolean,
  loadInProgress: boolean,
  selectedRoleIdsByUsers: { [key: string]: string[] }
}

export interface ISelectionOptionsStore {
  users: Array<User>
  gstins: Array<ICheckableItem>,
  gstinsByEntities: { [key: string]: Array<ICheckableItem> },
  entities: Array<ICheckableItem>,
  roles: {[key: string]: {id: number, name: string}[] }
}
