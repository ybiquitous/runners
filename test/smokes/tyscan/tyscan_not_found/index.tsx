import * as React from 'react';

interface User {
  readonly id: number
  readonly name: string
  readonly fullName: string
}

interface Props {
  readonly user: User
}

const MyPage = ({ user }: Props) => (
  <div>{`Hello, ${user.name}`}</div>
)

export default MyPage
