import PropTypes from 'prop-types';
import React from 'react';
import Select from 'react-select';
import { TextField } from 'office-ui-fabric-react/lib/TextField';

export default class ApiTester extends React.Component {

  /**
   * @param props - Comes from your rails view.
   * @param _railsContext - Comes from React on Rails
   */
  constructor(props, _railsContext) {
    super(props);
    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
    this.state = {
      response: {},
      errorToDisplay: {},
      method: 'get',
      data: {
        hostname: 'goog.ecom',
        method: 'get',
        body: {},
        headers: {
          'Content-type': 'application/json',
          'client-id': 'test_gsp63',
          'client-secret': 'OUJDMTIzQEB1BU1NXT1JE137',
          'gstin': '29AAACW2789B1Z6',
          'ewb-user-id': '00ABLPK6554F000',
          'authtoken': '',
          'Access-Control-Allow-Origin': '*'
        }
      }
    };
  }

  methods = () => {
    return [{ value: 'post', label: 'post'},{ value: 'get', label: 'get'}]
  }

  setValueToState = (key, value) => {
    this.setState({
      ...this.state,
      data: {
        ...this.state.data,
        [key]: value
      }
    })
  }

  setValueToHeaders = (key, value) => {
    this.setState({
      ...this.state,
      data: {
        ...this.state.data,
        headers: {
          ...this.state.data.headers,
          [key]: value
        }
      }
    })

  }

  handleSubmit = (event) => {
    event.preventDefault();
    const {data} = this.state;
    const hostname = data.hostname;

    fetch(data.hostname, {
      method: data.method,
      body: JSON.parse(data['body']),
      headers: data['headers']})
     .then(res => res.json())
     . then(response => {
        this.setState({
          ...this.state,
          response: response
        })
     })
     .catch(reason => {
        this.setState({
        ...this.state,
        errorToDisplay: reason.json
        });
     })

  }

  render() {
    return (
      <div>
        <label>Hostname</label>

        <input type='text' value={this.state.data.hostname} onChange={(event) => this.setValueToState('hostname', event.target.value)} />
        <div className="row">
          <div className="col-sm-12">
            <label>Method</label>
            <Select
                name="form-field-name"
                value={this.state.data.method}
                options={this.methods()}
                placeholder= "Select Methods"
                onChange={(event) => this.setValueToState('method', event.value) }
              />
          </div>
        </div>
        <label>content type</label>
        <input type='text' value={this.state.data.headers['Content-type']} onChange={(event) =>this.setValueToHeaders('Content-type', event.target.value)} />
        <label>Gstin</label>
        <input type='text' value={this.state.data.headers['gstin']} onChange={(event) => this.setValueToHeaders('gstin', event.target.value)} />
        <label>Client Id</label>
        <input type='text' value={this.state.data.headers['client-id']} onChange={(event) => this.setValueToHeaders('client-id', event.target.value)} />
        <label>Client Secret</label>
        <input type='text' value={this.state.data.headers['client-secret']} onChange={(event) => this.setValueToHeaders('client-secret', event.target.value)} />
        <label>Auth token</label>
        <input type='text' value={this.state.data.headers['authtoken']} onChange={(event) => this.setValueToHeaders('authtoken', event.target.value)} />
        <TextField
          onChanged={(event) => this.setValueToState('body', event)}
          label='Body'
          value={this.state.data['body']}
          multiline
          rows={ 4 }
        />
        <button onClick={this.handleSubmit}>Submit</button>

        <div>
          {this.state.response &&
            <pre>{JSON.stringify(this.state.response, undefined, 2)}</pre>
          }
          {this.state.errorToDisplay &&
            <pre>{JSON.stringify(this.state.errorToDisplay, undefined, 2)}</pre>
          } 
        </div>
      </div>
    );
  }
}
