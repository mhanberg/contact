import React from 'react';
import {
  Panel,
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
    <Panel>
      <Panel.Heading>Rooms</Panel.Heading>
      <ListGroup>
        {renderRooms(rooms || [], currentRoom, setCurrentRoom)}
        <ListGroupItem onClick={openCreateRoomModal} key='createNewRoom'>Create new room</ListGroupItem>
      </ListGroup>
    </Panel>
  );
}

export default Rooms;
