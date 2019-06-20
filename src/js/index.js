import React from 'react'
import PropTypes from 'prop-types'
import { push } from 'connected-react-router'
import { Icon } from 'react-fa'

import AdminStaffDetailsSidePanel from './sidePanel'
import buildRolesContent from '../shared/buildRolesContentHelper'

const AdminStaffDetails = props => {
  const { employee, roles, isEmployeeFetching, isRolesFetching } = props

  if (isEmployeeFetching || isRolesFetching) {
    return (
      <div className='text-center'>
        <Icon pulse name='spinner' size='5x' />
      </div>
    )
  }

  if (!employee) {
    return <div className='text-center'>There is no staff with that id!</div>
  }

  const { full_name, email } = employee

  return (
    <div className='staff-details-box'>
      <div className='staff-details'>
        <div className='staff-employee-info'>
          <div className='box'>
            <h4 className='text-center border-bottom'>Full Name:</h4>
            <p>{full_name}</p>
          </div>
          <div className='box'>
            <h4 className='text-center border-bottom'>Info:</h4>
            <div className='staff-email'>
              <h4>Email:</h4>
              <a href={`mailto:${email}`}>{email}</a>
            </div>
            <div className='staff-roles'>
              <h4>Roles:</h4>
              <p className='capitalize'>{buildRolesContent(employee, roles)}</p>
            </div>
          </div>
        </div>
        <AdminStaffDetailsSidePanel employee={employee} roles={roles} />
      </div>
      <div className='staff-details-button box'>
        <button
          onClick={() => props.dispatch(push('/staff/admin/staff/'))}
          className='btn btn-danger'
        >
          BACK
        </button>
      </div>
    </div>
  )
}

AdminStaffDetails.propTypes = {
  isEmployeeFetching: PropTypes.bool,
  employee: PropTypes.object,
  isRolesFetching: PropTypes.bool,
  roles: PropTypes.array,
  dispatch: PropTypes.func
}

export default AdminStaffDetails
