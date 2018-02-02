import React from 'react';
import request from 'superagent';
import {snakeCase} from 'change-case';
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

class SignUp extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      email: '',
      username: '',
      firstName: '',
      lastName: '',
      password: '',
      passwordConfirmation: '',
    }
  }

  handleChange = key => {
    return  event => {
      this.setState({[key]: event.target.value});
    }
  }

  submitOnEnter = (e) => e.key === 'Enter' && this.signUp();

  signUp = () => {
    this.setState({isLoading: true});
    const{
      email,
      username,
      firstName,
      lastName,
      password,
      passwordConfirmation
    } = this.state;

    request
      .post('/api/v1/users')
      .set('accept', 'application/vnd.api+json')
      .set('content-type', 'application/vnd.api+json')
      .send({
        data: {
          type: "users",
          attributes: {
            email,
            username,
            first_name: firstName,
            last_name: lastName,
            password,
            password_confirmation: passwordConfirmation
          }
        }
      })
      .then(resp => {
        this.setState({isLoading: false});
        this.props.setAlert({style: 'success', message: "You've successfully signed up, time to log in!"});
        this.props.handleAuthClick();
      })
      .catch(err => {
        this.setState({isLoading: false, validationState: 'error', errors: err.response.body.errors});
      });
  }

  error = error => this.state.errors && this.state.errors[snakeCase(error)] && this.state.errors[snakeCase(error)][0];

  render() {
    return(
      <Row>
        <Col xs={12} lg={6} lgOffset={3}>
          <Panel>
            <Panel.Heading>Sign Up</Panel.Heading>
            <Panel.Body>
              <FormGroup validationState={this.state.validationState}>
                <ControlLabel>Email</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.email} type='email' placeholder="Email" onChange={this.handleChange('email')} /> 
                <HelpBlock> {this.error('email')} </HelpBlock>

                <ControlLabel>Username</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.username} placeholder="Username" onChange={this.handleChange('username')} /> 
                <HelpBlock> {this.error('username')} </HelpBlock>

                <ControlLabel>First Name</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.firstName} placeholder="First Name" onChange={this.handleChange('firstName')} /> 
                <HelpBlock> {this.error('firstName')} </HelpBlock>

                <ControlLabel>Last Name</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.lastName} placeholder="Last Name" onChange={this.handleChange('lastName')} /> 
                <HelpBlock> {this.error('lastName')} </HelpBlock>

                <ControlLabel>Password</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.password} type='password' placeholder="Password" onChange={this.handleChange('password')} /> 
                <HelpBlock> {this.error('password')} </HelpBlock>

                <ControlLabel>Password Confirmation</ControlLabel>
                <FormControl onKeyPress={this.submitOnEnter} value={this.state.passwordConfirmation} type='password' placeholder="Password Confirmation" onChange={this.handleChange('passwordConfirmation')} /> 
                <HelpBlock> {this.error('passwordConfirmation')} </HelpBlock>

                <Button 
                  onClick={this.state.isLoading ? null : this.signUp}
                  disabled={this.state.isLoading}>
                  {this.state.isLoading ? 'Loading...' : 'Sign up!'}
                </Button>
              </FormGroup>
            </Panel.Body>
          </Panel>
        </Col>
      </Row>
    );
  }
}  
export default SignUp;
