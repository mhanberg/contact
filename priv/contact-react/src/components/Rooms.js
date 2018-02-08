import React from 'react';
import {
  Panel,
  Row,
  Col,
  ListGroup,
  ListGroupItem
} from 'react-bootstrap';


const renderRooms = (rooms, currentRoom, setCurrentRoom) => {
  return rooms.map(room => {
    return (<ListGroupItem 
      key={room.name}
      active={room.id === currentRoom.id}
      onClick={setCurrentRoom(room)}
    >
      {room.name}
    </ListGroupItem>);
  });
}

const Rooms = props => {
  const {
    rooms,
    currentRoom,
    openCreateRoomModal,
    setCurrentRoom
  } = props;

  return(
    <Row>
      <Col xs={12} lg={3}>
        <Panel>
          <Panel.Heading>Rooms</Panel.Heading>
          <ListGroup>
            {renderRooms(rooms || [], currentRoom, setCurrentRoom)}
            <ListGroupItem onClick={openCreateRoomModal} key='createNewRoom'>Create new room</ListGroupItem>
          </ListGroup>
        </Panel>
      </Col>
    </Row>
  );
}

export default Rooms;
