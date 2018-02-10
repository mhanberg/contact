import React from 'react';
import Rooms from './Rooms';
import request from 'superagent';
import {getSession} from '../util/session';
import CreateRoomModal from './CreateRoomModal';
import Elm from 'react-elm-components';
import {Chat} from '../elm/Chat.elm';
import {
  Row,
  Col
} from 'react-bootstrap';

class Home extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      rooms: [],
      currentRoom: {id: null},
      showCreateRoomModal: false
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevProps !== this.props) {
      if (this.props.userId && this.props.teamId) {
        request
          .get(`/api/v1/users/${this.props.userId}/teams/${this.props.teamId}/rooms`)
          .accept('application/vnd.api+json')
          .type('application/vnd.api+json')
          .set('authorization', `Bearer ${getSession()}`)
          .then(resp => {
            const rooms = resp.body.data.map(r => ({...r.attributes, id: r.id}));
            this.setState({rooms, currentRoom: rooms[0]})
          })
          .catch(err => console.log(err));
      }
    }
  }

  openCreateRoomModal = () => {
    this.setState({showCreateRoomModal: true});
  }

  setCurrentRoom = room => {
    return () => {
      this.setState({currentRoom: room});
    }
  }

  render() {
    return(
      <div>
        <CreateRoomModal teamId={this.props.teamId} currentUserId={this.props.userId} setAlert={this.props.setAlert} close={() => this.setState({showCreateRoomModal: false})} show={this.state.showCreateRoomModal}/>
        <Row>
          <Col xs={6} lg={3}>
            <Rooms 
              setCurrentRoom={this.setCurrentRoom} 
              rooms={this.state.rooms} 
              currentRoom={this.state.currentRoom} 
              openCreateRoomModal={this.openCreateRoomModal} />
          </Col>
          <Col lg={6} xs={6}>
            <Elm src={Chat}/>
          </Col>
        </Row>
      </div>
    );
  }
}

export default Home;
