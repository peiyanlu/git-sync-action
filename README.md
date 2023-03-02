# Git Sync Action
一个GitHub操作，用于通过 `SSH` 将 `git仓库` 同步到另一个位置，可以是某个分支，也可以是[整个仓库](https://help.github.com/en/articles/duplicating-a-repository#mirroring-a-repository-in-another-location)。

声明：内容参考自 [Git Mirror Action](https://github.com/wearerequired/git-mirror-action), 稍作修改适用于自己的需求。

## Inputs

### `source-repo`

**Required** 源仓库的SSH URL。

### `destination-repo`

**Required** 目标仓库的SSH URL。

### `destination-branch`

**Optional** 目标仓库的分支；若是存在，则同步指定分支，反之镜像整个仓库。

### `dry-run`

**Optional** *(default: `false`)* 执行试运行。所有步骤都会执行，但不会将任何更新推送到目标存储库。

## Environment secrets

- `SSH_PRIVATE_KEY`: 创建一个不带密码的 [SSH密钥](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) 用来访问两个仓库。在 GitHub 上，您可以将公钥作为 [仓库的 Deploy Keys](https://docs.github.com/en/developers/overview/managing-deploy-keys#deploy-keys)。GitLab 同样有 [具有写入权限的 Deploy Keys](https://docs.gitlab.com/ee/user/project/deploy_keys/)，对于任何其他服务，您可能需要将公钥添加到您的个人帐户中。

- `SSH_KNOWN_HOSTS`: `known_hosts` 文件中使用的known_hosts。如果变量不可用，则禁用 *StrictHostKeyChecking*

如果你在 [environment](https://docs.github.com/en/actions/reference/environments) 中添加了 `SSH_PRIVATE_KEY` 或者 `SSH_KNOWN_HOSTS`， 确保 [在workflow中引用环境变量名称](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idenvironment) 否则不会传递给 `workflow`

> path: Settings -> Environments -> enviroment name -> Environment secrets
> > 使用前请先指定 environment，如下：
```yml
jobs:
  git-sync:
    runs-on: ubuntu-latest
    environment: 
      name: your enviroment name
    steps:
```

> `github secrets` 分三类：`environment secrets` 优先级最高，然后是 `rapository secrets`、 `orgnization secrets`

## Example workflow

```yml
name: Sync to Bitbucket Repo

on: [ push, delete, create ]

# Ensures that only one mirror task will run at a time.
concurrency:
  group: git-sync

jobs:
  git-sync:
    runs-on: ubuntu-latest
    steps:
      - uses: peiyanlu/git-sync-action@v1
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
          SSH_KNOWN_HOSTS: ${{ secrets.SSH_KNOWN_HOSTS }}
        with:
          source-repo: "git@github.com:peiyanlu/git-sync-action.git"
          destination-repo: "git@gitee.com:peiyanlu/git-sync-action.git"
          destination-branch: gh-pages
```

## Docker

```sh
docker run --rm -e "SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)" $(docker build -q .) "$SOURCE_REPO" "$DESTINATION_REPO" "$DESTINATION_BRANCH"
```


## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
