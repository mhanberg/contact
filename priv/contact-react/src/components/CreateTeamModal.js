import React from 'react';
import request from 'superagent';
import {
  Modal,
  FormGroup,
  FormControl,
  HelpBlock,
  Button,
  ControlLabel
} from 'react-bootstrap';
import {getSession} from '../util/session';

class CreateTeamModal extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      show: this.props.show,
      isLoading: false,
      name: ''
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({show: nextProps.show});
  }

  close = () => {
    this.setState({show: false});
    this.props.close();
  }  

  handleChange = key => {
    return event => this.setState({[key]: event.target.value});
  }

  createTeam = () => {
    this.setState({isLoading: true});
    request
      .post('/api/v1/teams')
      .accept('application/vnd.api+json')
      .type('application/vnd.api+json')
      .set('authorization', `Bearer ${getSession()}`)
      .send({
        data: {
          type: "teams",
          attributes: {
            name: this.state.name,
            owner_id: this.props.currentUser.id
          }
        }
      })
      .then(resp => {
        this.props.setAlert({stye: 'success', message: 'Team Successfully Created'});
        this.setState({show: false, isLoading: false, name: ''});
        this.props.close(true);
      })
      .catch(err => {
        this.setState({isLoading: false, validationState: 'error'});
      })
  }

  render() {
    return(
      <Modal show={this.state.show} onHide={this.close}>
        <Modal.Header closeButton><Modal.Title>Create a new team!</Modal.Title></Modal.Header>
        <Modal.Body>
          <FormGroup validationState={this.state.validationState}>
            <ControlLabel>Team Name</ControlLabel>
            <FormControl maxLength={25} value={this.state.name} placeholder="Team Name" onChange={this.handleChange('name')} />
            <HelpBlock />
            <Button
              onClick={this.state.isLoading ? null : this.createTeam}
              disabled={this.state.isLoading}
            >
              {this.state.isLoading ? 'Creating...' : 'Create'}
            </Button>
          </FormGroup>
        </Modal.Body>
      </Modal>
    )
  }
}

export default CreateTeamModal;
