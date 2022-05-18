import ReactOnRails from 'react-on-rails';

import DscRegister from '../components/DscRegister';
import SignedData from '../components/SignedData';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  DscRegister,
  SignedData,
});
