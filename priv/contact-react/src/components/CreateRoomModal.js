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

class CreateRoomModal extends React.Component {
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

  handleChange = (key) => {
    return event => this.setState({[key]: event.target.value});
  }

  createRoom = () => {
    console.log(this.props);
    this.setState({isLoading: true});
    request
      .post('/api/v1/rooms')
      .accept('application/vnd.api+json')
      .type('application/vnd.api+json')
      .set('authorization', `Bearer ${getSession()}`)
      .send({
        data: {
          type: "rooms",
          attributes: {
            name: this.state.name,
            owner_id: this.props.currentUser,
            team_id: this.props.team
          }
        }
      })
      .then(resp => {
        this.props.setAlert({style: 'success', message: 'Room Successfully Created'});
        this.setState({show: false, isLoading: false});
        this.props.close();
      })
      .catch(err => {
        this.setState({isLoading: false, validationState: 'error'});
      })
  }

  render() {
    return(
      <Modal show={this.state.show} onHide={this.close}>
        <Modal.Header closeButton><Modal.Title>Create a new room!</Modal.Title></Modal.Header>
        <Modal.Body>
          <FormGroup validationState={this.state.validationState}>
            <ControlLabel>Room Name</ControlLabel>
            <FormControl value={this.state.name} placeholder="Room Name" onChange={this.handleChange('name')} />
            <HelpBlock />
            <Button
              onClick={this.state.isLoading ? null : this.createRoom}
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

export default CreateRoomModal;
