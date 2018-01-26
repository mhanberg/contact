# Contact
[![Build Status](https://travis-ci.org/mhanberg/contact.svg?branch=master)](https://travis-ci.org/mhanberg/contact)

## Roadmap

### V1 

#### Authentication

- [x] login POST /api/v1/users/sign\_in

#### Users

- [x] create POST /api/v1/users
- [x] show GET /api/v1/users/:id
- [x] update PUT /api/v1/users
- [x] delete DELETE /api/v1/users/:id
- [ ] index GET /api/v1/users/:id

#### Teams

- [x] create POST /api/v1/teams
- [x] show GET /api/v1/teams/:id
- [x] update PUT /api/v1/teams
- [x] delete DELETE /api/v1/teams/:id
- [ ] index GET /api/v1/teams/:id

#### Members (team)

- [x] create POST /api/v1/teams/:team\_id/users
- [x] show GET /api/v1/teams/:team\_id/users/:id
- [x] update PUT /api/v1/teams/:team\_id/users
- [x] delete DELETE /api/v1/teams/:team\_id/users/:id
- [ ] index GET /api/v1/teams/:team\_id/users/:id

#### Rooms

- [x] create POST /api/v1/rooms
- [x] show GET /api/v1/rooms/:id
- [x] update PUT /api/v1/rooms
- [x] delete DELETE /api/v1/rooms/:id
- [ ] index GET /api/v1/rooms/:id

#### Members (room)

- [ ] create POST /api/v1/rooms/:room\_id/users
- [ ] show GET /api/v1/rooms/:room\_id/users/:id
- [ ] update PUT /api/v1/rooms/:room\_id/users
- [ ] delete DELETE /api/v1/rooms/:room\_id/users/:id
- [ ] index GET /api/v1/rooms/:room\_id/users/:id

#### Messaging

- [ ] rooms:\*
