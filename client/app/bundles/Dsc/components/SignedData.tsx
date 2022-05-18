import PropTypes from 'prop-types';
import * as React from 'react';
import {Dsc} from './Dsc';

export default class SignedData extends React.Component<any, any> {

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
      isResponseSet: false,
      panNumber: "",
      unsignedJson: "",
      auth_header: this.props.auth_header
    };
  }
  
  render() {
    return (
      <div>
        STEPS: 
        <p> 1. Enter your pan number</p>
        <p> 2. Enter your Data</p>
        <p> 3. Click on Sign button</p>

        <label>PAN Number </label>
        <input type='text' onChange={(e) => this.setState({...this.state, panNumber: e.target.value })} />
        <label>Unsigned Json </label>
        <input type='text' onChange={(e) => this.setState({...this.state, unsignedJson: e.target.value })} />
        <Dsc unsignedData={this.state.unsignedJson} panNumber={this.state.panNumber} onResponse={(data) => this.setState({...this.state, response: data, isResponseSet: true})} />
        Sign Response:
        <pre>{ this.state.isResponseSet && JSON.stringify(this.state.response, undefined, 2)}</pre>
      </div>
    );
  }
}
