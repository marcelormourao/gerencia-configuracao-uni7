#!/bin/bash
# Bug do cloud-init vs ansible requer que a variável HOME esteja explicitamente setada.
# Ver https://github.com/ansible/ansible/issues/31617#issuecomment-337029203
export HOME=/root
echo "sudo halt" | at now + 10 minutes