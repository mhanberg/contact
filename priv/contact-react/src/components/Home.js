import React from 'react';
import {
  Row,
  Col,
  FormControl,
  Button
} from 'react-bootstrap';
import Rooms from './Rooms';
import request from 'superagent';
import {getSession} from '../util/session';
import CreateRoomModal from './CreateRoomModal';
import {Socket} from 'phoenix';
import '../styles/Home.css';
class Home extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      rooms: [],
      currentRoom: {id: null},
      showCreateRoomModal: false,
      message: '',
      messages: []
    }
  }

  joinChannel = () => {
    let channel = this.state.socket.channel(`room:${this.state.currentRoom.id}`) ;
    channel.on("new_msg", msg => {
      this.setState((prevState) => ({messages: prevState.messages.concat(msg)}));
    } )
    channel.join()
      .receive("ok", ({messages}) => console.log("catching up", messages) )
      .receive("error", ({reason}) => console.log("failed join", reason) )
      .receive("timeout", () => console.log("Networking issue. Still waiting..."))
    this.setState({channel});
  }

  componentDidMount() {
    const socket = new Socket("ws://localhost:4000/socket", {params: {token: getSession()}});
    socket.connect();
    this.setState({socket});
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

    if (prevState.currentRoom !== this.state.currentRoom) {
      this.joinChannel()
    }
  }

  renderMessages = () => {
    const messages = this.state.messages.map((msg, i) => {
      return <li key={i}>{msg.body}</li>;
    });
    return messages;
  }

  openCreateRoomModal = () => {
    this.setState({showCreateRoomModal: true});
  }

  setCurrentRoom = room => {
    return () => {
      this.setState({currentRoom: room});
    }
  }

  sendMessage = () => {
    console.log("in send message");
    console.log(this.props);
    this.state.channel.push("new_msg", {body: this.state.message, sender_id: this.props.userId, room_id: this.state.currentRoom.id}, 10000)
      .receive("ok", (msg) => console.log("created message", msg) )
      .receive("error", (reasons) => console.log("create failed", reasons) )
      .receive("timeout", () => console.log("Networking issue...") )

    this.setState({message: ''});
  }

  render() {
    return(
      <div>
        <CreateRoomModal teamId={this.props.teamId} currentUserId={this.props.userId} setAlert={this.props.setAlert} close={() => this.setState({showCreateRoomModal: false})} show={this.state.showCreateRoomModal}/>
        <Row>
          <Col lg={3}>
            <Rooms 
              setCurrentRoom={this.setCurrentRoom} 
              rooms={this.state.rooms} 
              currentRoom={this.state.currentRoom} 
              openCreateRoomModal={this.openCreateRoomModal} />
          </Col>
          <Col lg={6}>
            <Row>
              <div id="messages" className="message-box">
                <ul>
                  {this.renderMessages()}
                </ul>
              </div>
            </Row>
            <Row>
              <Col lg={9}>
                <FormControl id="chat-input" type="text" value={this.state.message} onChange={(e) => this.setState({message: e.target.value})}/>
              </Col>
              <Col lg={3}>
                <Button onClick={this.sendMessage}>Send</Button>
              </Col>
            </Row>
          </Col>
        </Row>
      </div>
    );
  }
}

export default Home;
