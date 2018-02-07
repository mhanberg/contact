import React from 'react';
import {
  Panel,
  Row,
  Col,
  ListGroup,
  ListGroupItem
} from 'react-bootstrap';


const renderRooms = (rooms, currentRoom) => {
  return rooms.map(room => {
    return <ListGroupItem 
      key={room.name}
      active={room.id === currentRoom.id}
    >
      {room.name}
    </ListGroupItem>
  });
}

const Room = (props) => {
  const {
    rooms,
    currentRoom,
    openCreateRoomModal
  } = props;

  return(
    <Row>
      <Col xs={12} lg={3}>
        <Panel>
          <Panel.Heading>Rooms</Panel.Heading>
          <ListGroup>
            {renderRooms(rooms || [], currentRoom, openCreateRoomModal)}
            <ListGroupItem onClick={openCreateRoomModal} key='createNewRoom'>Create new room</ListGroupItem>
          </ListGroup>
        </Panel>
      </Col>
    </Row>
  );
}

export default Room;
