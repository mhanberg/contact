import React from 'react';
import {
  Panel,
  Row,
  Col,
  ListGroup,
  ListGroupItem
} from 'react-bootstrap';


const renderRooms = (rooms) => {
  return rooms.map(room => <ListGroupItem key={room.name}>{room.name}</ListGroupItem>)
}

const Room = (props) => {
  const {
    rooms
  } = props;

  return(
    <Row>
      <Col xs={12} lg={3}>
        <Panel>
          <Panel.Heading>Rooms</Panel.Heading>
          <ListGroup>
            {renderRooms(rooms || [])}
          </ListGroup>
        </Panel>
      </Col>
    </Row>
  );
}

export default Room;
