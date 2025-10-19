# n8n for Pterodactyl

![N8N Logo](https://n8n.io/images/n8n-logo.png)

## About the Project

This repository contains an implementation of n8n ([https://n8n.io/](https://n8n.io/)) optimized to run on [Pterodactyl](https://pterodactyl.io/) servers. n8n is a powerful workflow automation platform that lets you connect different systems and services without needing programming knowledge.

## Features

- Docker image optimized for Pterodactyl
- Automatic environment configuration via variables
- SQLite support for local storage
- Predefined security configuration
- Task runner support for better performance

## Requirements

- Pterodactyl server
- Compatible n8n egg
- At least 1GB RAM recommended
- 2 vCPUs recommended

## Installation

1. Import the `egg-n8n.json` file into your Pterodactyl panel
2. Create a new server using the egg
3. Start the server

## Environment Variables

| Variable                                | Description                | Default Value |
| --------------------------------------- | -------------------------- | ------------- |
| `N8N_VERSION`                           | n8n version to install     | latest        |
| `N8N_PROTOCOL`                          | HTTP or HTTPS protocol     | http          |
| `N8N_SECURE_COOKIE`                     | Use secure cookies         | false         |
| `GENERIC_TIMEZONE`                      | Server timezone            | UTC           |
| `N8N_DB_TYPE`                           | Database type              | sqlite        |
| `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS` | Enforce secure permissions | true          |
| `N8N_RUNNERS_ENABLED`                   | Enable task runners        | true          |

## Usage

After installation, access n8n at:

```
http://your-server:port
```

On first run, you’ll need to set up an admin user.

## Persistence

Data is stored at:

```
/home/container/.n8n/
```

Make sure this directory is included in backups in Pterodactyl.

## Example Use Cases

Here are some examples of what you can do with n8n:

- Integrate data between systems (Stripe, Shopify, Google Sheets)
- Create social media automations
- Implement alerts and notifications for systems
- Sync data across different services
- Perform automated data processing

## Updating

To update n8n to a new version:

1. Go to the Pterodactyl panel
2. Stop the server
3. Update the `N8N_VERSION` environment variable to the desired version
4. Restart the server

## Security

Recommendations to increase security:

- Set `N8N_PROTOCOL` to `https` if you have a certificate
- Use strong passwords for your admin user
- Limit access to your n8n server via firewall
- Consider implementing external authentication

## Frequently Asked Questions (FAQ)

**Q: Does n8n support external databases?**  
A: Yes. You can configure MySQL, PostgreSQL, or other supported databases via environment variables.

**Q: Can I run tasks in the background?**  
A: Yes. Task runners are enabled by default for efficient execution.

**Q: How do I back up my workflows?**  
A: Configure regular backups of the `/home/container/.n8n/` directory in the Pterodactyl panel.

## Additional Resources

- [n8n Official Documentation](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [Pterodactyl Documentation](https://pterodactyl.io/project/introduction.html)
- [Video Tutorials (YouTube)](https://www.youtube.com/c/n8n_io)

## Troubleshooting

- **Connection error**: Check that ports are correctly configured in Pterodactyl.
- **Out of memory**: Increase the server’s memory allocation.
- **Webhook not working**: Check the `N8N_WEBHOOK_URL` variable configuration.
- **Startup error**: Check the server logs to identify the specific issue.
- **Slow performance**: Increase server resources or optimize your workflows.

## Known Limitations

- On resource-constrained servers, complex workflows may experience timeouts
- Some specific n8n nodes may require additional configuration to work properly
- SSH access to the container may be necessary for advanced debugging

## Contributing

Contributions are welcome! Please open a pull request or an issue to discuss proposed changes.

## License

This project is distributed under the same license as n8n. See more details on the [official n8n website](https://n8n.io/licensing/).

## Credits

- [n8n](https://n8n.io/) - Workflow automation platform
- [Pterodactyl](https://pterodactyl.io/) - Server management platform
- [Eletriom](https://eletriom.com.br) - Author of this implementation
- [Bill](https://bill-zhanxg.com) - Current maintainer
