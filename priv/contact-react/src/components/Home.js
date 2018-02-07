import React from 'react';
import Rooms from './Rooms';
import request from 'superagent';
import {getSession} from '../util/session';
import CreateRoomModal from './CreateRoomModal';

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
      request
        .get(`/api/v1/users/${this.props.user}/teams/${this.props.team}/rooms`)
        .accept('application/vnd.api+json')
        .type('application/vnd.api+json')
        .set('authorization', `Bearer ${getSession()}`)
        .then(resp => {
          const rooms = resp.body.data.map(r => ({...r.attributes, id: r.id}));
          this.setState({rooms, currentRoom: rooms[0] || {id: null}});
        })
        .catch(err => console.log(err));
    }
  }

  openCreateRoomModal = () => {
    this.setState({showCreateRoomModal: true});
  }
  
  render() {
    return(
      <div>
        <CreateRoomModal team={this.props.team} currentUser={this.props.user} setAlert={this.props.setAlert} close={() => this.setState({showCreateRoomModal: false})} show={this.state.showCreateRoomModal}/>
        <Rooms rooms={this.state.rooms} currentRoom={this.state.currentRoom} openCreateRoomModal={this.openCreateRoomModal}/>
      </div>
    );
  }
}

export default Home;
