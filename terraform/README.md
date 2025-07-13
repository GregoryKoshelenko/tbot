# tbot-infra: Terraform + FluxCD для автоматичного деплою tbot

## Опис

Цей проект автоматизує розгортання PET-проєкту tbot у Kubernetes (GKE або локальний kind) через FluxCD та GitHub Actions. Зміна коду в helm chart автоматично оновлює деплой у кластері.

### Основні компоненти
- **GKE/Kind кластер**: вибір середовища для тестів та продакшн
- **FluxCD**: GitOps-інструмент для автоматичного деплою
- **GitHub Repository**: створюється автоматично через Terraform для зберігання FluxCD manifests та Helm chart
- **HelmRelease**: деплой tbot через helm chart
- **TLS Keys**: автоматична генерація ключів для безпеки

## Інструкція

1. Встановіть Terraform >=1.3
2. Заповніть `terraform/vars.tvars`:
   - GOOGLE_REGION, GOOGLE_PROJECT, GITHUB_TOKEN, GITHUB_OWNER
3. Запустіть локальний кластер kind:
   - Переконайтесь, що Docker запущений
   - Виконайте:
   ```bash
   cd terraform
   terraform init
   terraform apply -var-file=vars.tvars
   ```
   Це створить локальний Kubernetes кластер через kind, згенерує TLS ключі, створить GitHub репозиторій та встановить FluxCD.
4. Перевірте FluxCD:
   - Відкрийте автоматично створений репозиторій tbot
   - Змініть версію у helm chart
   - Переконайтесь, що деплой у кластері оновився (FluxCD автоматично застосує зміни)

## Автоматизація
- Весь код, Helm chart, FluxCD manifests та інфраструктура знаходяться у цьому репозиторії.
- Підтримка автоматичного оновлення через FluxCD та GitHub Actions.
- Для керування кластером використовуйте k9s або kubectl (kubeconfig генерується автоматично).
