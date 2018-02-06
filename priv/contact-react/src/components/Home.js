import React from 'react';
import Rooms from './Rooms';
import request from 'superagent';
import {getSession} from '../util/session';

class Home extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      rooms: []
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
          this.setState({rooms});
        })
        .catch(err => console.log(err));
    }
  }

  render() {
    return(
      <Rooms rooms={this.state.rooms}/>
    );
  }
}

export default Home;
