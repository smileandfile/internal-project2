import ReactOnRails from 'react-on-rails';

import Gstr3bForm from '../components/Gstr3bForm';
import RequestOtp from '../components/RequestOtp';
import GetGstr3bDetails from '../components/GetGstr3bDetails';
import OffsetLiability from '../components/OffsetLiability';
import SubmitGstr3b from '../components/SubmitGstr3b';
import TrackStatus from '../components/TrackStatus';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
  Gstr3bForm,
  RequestOtp,
  GetGstr3bDetails,
  OffsetLiability,
  SubmitGstr3b,
  TrackStatus,
});
