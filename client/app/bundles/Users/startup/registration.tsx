import ReactOnRails from 'react-on-rails';

import {UserPermissionsApp} from '../components/UserPermissionsApp';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  UserPermissionsApp,
});
