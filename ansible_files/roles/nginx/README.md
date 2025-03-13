# NGINX Role

This directory contains the Ansible role for managing NGINX on target servers.

## Overview

The NGINX role is designed to install and configure NGINX, ensuring that it is properly set up to serve web content. This role can be used in conjunction with other roles to create a complete web server environment.

## Directory Structure

- **tasks/**: Contains the main tasks for installing and configuring NGINX.
- **handlers/**: Contains handlers that can be triggered by tasks (e.g., restarting NGINX).
- **templates/**: Contains Jinja2 templates for NGINX configuration files.
- **files/**: Contains static files that may be needed for NGINX.
- **vars/**: Contains variables specific to this role.
- **defaults/**: Contains default variables for this role.
- **meta/**: Contains metadata about the role, including dependencies.

## Usage

To use this role, include it in your playbook as follows:

```yaml
- hosts: webservers
  roles:
    - nginx
```

## Requirements

Ensure that the target servers meet the prerequisites for installing NGINX, including having the necessary package manager and network access.

## License

This role is licensed under the MIT License.