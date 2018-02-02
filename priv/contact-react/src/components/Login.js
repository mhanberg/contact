import React from 'react';
import {putSession} from '../util/session';
import request from 'superagent';
import {
  FormGroup,
  FormControl,
  ControlLabel,
  Row,
  Col,
  Panel,
  HelpBlock,
  Button
} from 'react-bootstrap';

class Login extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      login: '',
      password: ''
    }
  }

  handleChange = key => {
    return  event => {
      this.setState({[key]: event.target.value});
    }
  }
  
  submitOnEnter = (e) => e.key === 'Enter' && this.login();

  login = () => {
    this.setState({isLoading: true});
    const{
      login,
      password
    } = this.state;

    request
      .post('/api/v1/users/sign_in')
      .set('accept', 'application/vnd.api+json')
      .set('content-type', 'application/vnd.api+json')
      .send({
        data: {
          type: "users",
          attributes: {
            login,
            password
          }
        }
      })
      .then(resp => {
        putSession(resp.body.data.attributes.token);
        this.setState({isLoading: false});
        this.props.handleAuthClick();
      })
      .catch(err => {
        this.setState({isLoading: false, validationState: 'error', errors: 'Login/password is incorrect'});
      });
  }

  render() {
    return(
      <Row>
        <Col xs={12} lg={6} lgOffset={3}>
          <Panel>
            <Panel.Heading>Login</Panel.Heading>
            <Panel.Body>
              <FormGroup validationState={this.state.validationState}>
                <ControlLabel>Login</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.login}  placeholder="Email or Username" onChange={this.handleChange('login')} /> 

                <ControlLabel>Password</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.password} type='password' placeholder="Password" onChange={this.handleChange('password')} /> 
                <HelpBlock> {this.state.errors} </HelpBlock>

                <Button 
                  onClick={this.state.isLoading ? null : this.login}
                  disabled={this.state.isLoading}>
                  {this.state.isLoading ? 'Loading...' : 'Login'}
                </Button>
              </FormGroup>
            </Panel.Body>
          </Panel>
        </Col>
      </Row>
    );
  }
}  
export default Login;
