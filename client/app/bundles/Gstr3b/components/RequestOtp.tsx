import PropTypes from 'prop-types';
import * as React from 'react';
import { Dropdown, DropdownMenuItemType } from 'office-ui-fabric-react/lib/Dropdown';
import { TextField } from 'office-ui-fabric-react/lib/TextField';
import * as update from 'immutability-helper';
import { Modal } from 'office-ui-fabric-react/lib/Modal';
import { PrimaryButton, DefaultButton } from 'office-ui-fabric-react/lib/Button';
import { ChoiceGroup } from 'office-ui-fabric-react/lib/ChoiceGroup';


export default class RequestOtp extends React.Component<any, any> {

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
      showModal: false,
      set_gstin_url: this.props.set_gstin_url,
      request_otp_url: this.props.request_otp_url,
      confirm_otp_url: this.props.confirm_otp_url,
      gstr3b_index_url: this.props.gstr3b_index_url


    };
  }

  handleSubmit = (event) => {
    const method = "POST";
    const hostname = this.state.request_otp_url;
    fetch(hostname, {
       method: 'POST',
       headers: {
          'access-token': this.state.auth_header['access-token'],
          'token-type': this.state.auth_header['token-type'],
          'expiry': this.state.auth_header['expiry'],
          'client': this.state.auth_header['client'],
          'uid': this.state.auth_header['uid'],
          'gstin-id': this.state.auth_header['gstin-id'],
          'domain-name': this.state.auth_header['domain-name']
        }})
      .then(res => res.json())
      .then(this._showModal.bind(this));
      
      
    event.preventDefault();
  }

  handleSubmitOtp = (event) => {
    const method = "POST";
    const hostname = this.state.confirm_otp_url;
    const gstr3b_index = this.props.gstr3b_index_url;
    const body = new FormData(event.target);
    fetch(hostname, {
       method: 'POST',
       body: body,
       headers: {
          'access-token': this.state.auth_header['access-token'],
          'token-type': this.state.auth_header['token-type'],
          'expiry': this.state.auth_header['expiry'],
          'client': this.state.auth_header['client'],
          'uid': this.state.auth_header['uid'],
          'gstin-id': this.state.auth_header['gstin-id'],
          'domain-name': this.state.auth_header['domain-name']
        }})
      .then(res => res.json())
      .then(function(res) {
        if(res.success) {
          return window.location.href = gstr3b_index;
        }
        return alert(JSON.stringify(res))
      })
      
      
    event.preventDefault();
  }  

  render() {
    return (
      <div>
        <a href={this.state.set_gstin_url} className='btn btn-default text-right'>Change GSTIN Number</a>
        <hr/>
        <p><strong>Gstin Number: </strong>{this.state.gstin.gstin_number}</p>
        <p><strong>GSP Username: </strong>{this.state.gstin.username}</p>
        <button onClick={this.handleSubmit} className='btn btn-default'>Request OTP</button>
        <Modal
          isOpen={ this.state.showModal }
          onDismiss={ this._closeModal.bind(this) }
          isBlocking={ false }
          containerClassName='ms-modalExample-container'
        >
        <div className="modal fade in" style={{display: 'block' }}>
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close"  onClick={ this._closeModal.bind(this) }>&times;</button>
                <h4 className="modal-title">Confirm Your OTP</h4>
              </div>
              <div className="modal-body">
                <h5>Please check your mail for OTP</h5>
                <form onSubmit={this.handleSubmitOtp} >
                    <TextField label='OTP' name='gstn[otp]' required={ true } />
                    <button className='btn btn-default'>Confirm OTP</button>
                </form>
              </div>
            </div>
              
            </div>
          </div>
        </Modal>
      </div>
    );
    
  }
  private _showModal() {
    this.setState({ showModal: true });
  }

  private _closeModal() {
    this.setState({ showModal: false });
  }
}
