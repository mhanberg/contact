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
  PageHeader,
  HelpBlock,
  Button
} from 'react-bootstrap';

class Login extends React.Component {
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

  token = resp => resp.body.attributes.token;

  handleChange = key => {
    return  event => {
      this.setState({[key]: event.target.value});
    }
  }

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
        alert('success!');
        console.log(resp);
        this.setState({isLoading: false});
      })
      .catch(err => {
        alert(JSON.stringify(err.response.body.errors));
        console.log(err.response);

        this.setState({isLoading: false, validationState: 'error', errors: err.response.body.errors});
      });
  }

  error = error => this.state.errors && this.state.errors[snakeCase(error)] && this.state.errors[snakeCase(error)][0];

  render() {
    return(
      <Row>
        <PageHeader>Welcome to Contact! <small>Sign Up</small></PageHeader>
        <Col xs={12} lg={6} lgOffset={3}>
          <Panel>
            <Panel.Heading>Sign Up</Panel.Heading>
            <Panel.Body>
              <FormGroup validationState={this.state.validationState}>
                <ControlLabel>Email</ControlLabel>
                <FormControl value={this.state.email} type='email' placeholder="Email" onChange={this.handleChange('email')} /> 
                <HelpBlock> {this.error('email')} </HelpBlock>

                <ControlLabel>Username</ControlLabel>
                <FormControl value={this.state.username} placeholder="Username" onChange={this.handleChange('username')} /> 
                <HelpBlock> {this.error('username')} </HelpBlock>

                <ControlLabel>First Name</ControlLabel>
                <FormControl value={this.state.firstName} placeholder="First Name" onChange={this.handleChange('firstName')} /> 
                <HelpBlock> {this.error('firstName')} </HelpBlock>

                <ControlLabel>Last Name</ControlLabel>
                <FormControl value={this.state.lastName} placeholder="Last Name" onChange={this.handleChange('lastName')} /> 
                <HelpBlock> {this.error('lastName')} </HelpBlock>

                <ControlLabel>Password</ControlLabel>
                <FormControl value={this.state.password} type='password' placeholder="Password" onChange={this.handleChange('password')} /> 
                <HelpBlock> {this.error('password')} </HelpBlock>

                <ControlLabel>Password Confirmation</ControlLabel>
                <FormControl value={this.state.passwordConfirmation} type='password' placeholder="Password Confirmation" onChange={this.handleChange('passwordConfirmation')} /> 
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
export default Login;
