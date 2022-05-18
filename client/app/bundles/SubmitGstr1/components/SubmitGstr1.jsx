import PropTypes from 'prop-types';
import React from 'react';

import Form from 'dist/react-jsonschema-form.js';

import GstSchema from 'gstn-json-schemas/gstn1/submit_gstr1/submit-gstr1.json'
import Gstr1FormData from 'gstn-json-schemas/gstn1/submit_gstr1/submit-gstr1-form-data.json'


export default class SubmitGstr1 extends React.Component {

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);
    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
    this.state = {
      name: this.props.name,
      schema: GstSchema,
      submitFormData: Gstr1FormData,
      auth_header: this.props.auth_header
    };
  }

  updateName = (name) => {
    this.setState({ name });
  };
  updateSchema = (schema) => {
    this.setState({ schema });
  };
  handleSubmit = (e) => {
    $.post({
      url: '/api/gstn1/submit_gstr1',
      method: 'post',
      data: JSON.stringify({data: e.formData }),
      headers: {
        'access-token': this.state.auth_header['access-token'],
        'token-type': this.state.auth_header['token-type'],
        'expiry': this.state.auth_header['expiry'],
        'client': this.state.auth_header['client'],
        'uid': this.state.auth_header['uid'],
        'gstin-id': this.state.auth_header['gstin-id']
      },
      contentType: 'application/json',
      processData: false,
      dataType: 'json'
    })
    .then(function(res){ return document.write(JSON.stringify(res)) })

  }

  render() {
    return (
      <div>
        <hr />
        <Form schema={this.state.schema} formData={this.state.submitFormData} onSubmit={this.handleSubmit}/>
      </div>
    );
  }
}
