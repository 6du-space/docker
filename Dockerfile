FROM ubuntu:19.04

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
ENV PATH="~/.cargo/bin:~/.yarn/bin:~/.config/yarn/global/node_modules/.bin:${PATH}"
RUN apt-get update && apt-get install --assume-yes apt-utils
RUN apt-get install -y git software-properties-common curl wget sudo rsync libssl-dev pkg-config cmake
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN add-apt-repository ppa:neovim-ppa/stable -y
#RUN add-apt-repository ppa:chris-lea/redis-server -y
#RUN add-apt-repository ppa:jonathonf/vim -y
#RUN add-apt-repository ppa:deadsnakes/ppa -y

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt disco main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

RUN apt-get update
RUN apt-get upgrade -y
ENV RUSTUP_HOME=/usr/local
ENV CARGO_HOME=/usr/local
#ENV RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
#ENV RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
RUN cargo install exa --root /usr/local
RUN cargo install tealdeer --root /usr/local
RUN cargo install sd fd-find tokei diskus --root /usr/local
RUN apt-get install --allow-unauthenticated -y python3.7 python3.7-dev python-pip jq tzdata postgresql-client locales ncdu gem libpq-dev rpl lsof iputils-ping whois jq zsh openssh-server tmux tree htop cron tree ctags neovim autojump mlocate redis-server ruby python3-distutils ripgrep logrotate
RUN gem install gist
RUN locale-gen zh_CN.UTF-8
RUN update-locale LC_ALL=zh_CN.UTF-8 LANG=zh_CN.UTF-8
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata
RUN mkdir -p /run/sshd
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
RUN (echo -e "#分　时　日　月　周　命令\n#第1列表示分钟1～59 每分钟用*或者 */1表示\n#第2列表示小时1～23（0表示0点）\n#第3列表示日期1～31\n#第4列表示月份1～12\n#第5列标识号星期0～6（0表示星期天）\n#第6列要运行的命令\n\n3 3 * * 6 zsh -c 'DISABLE_AUTO_UPDATE=true && export ZSH=$HOME/.oh-my-zsh && source $ZSH/oh-my-zsh.sh && upgrade_oh_my_zsh 2>&1' >> /dev/null\n0 3 * * * logrotate /etc/logrotate.conf") | crontab -
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 2
RUN update-alternatives --set python /usr/bin/python2.7
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN pip2 install supervisor
RUN pip3 install virtualenv ipython pipenv xonsh
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf
RUN cd ~/.asdf && git checkout "$(git describe --abbrev=0 --tags)"
RUN . ~/.asdf/asdf.sh && asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git && bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring &&  nodejsVersion=`asdf list-all nodejs|tail -n 1` && asdf install nodejs $nodejsVersion && asdf global nodejs  $nodejsVersion && npm install -g yarn prettier npm-check-updates taskbook livescript-transform-implicit-async livescript livescript-system --unsafe-perm=true --allow-root --scripts-prepend-node-path
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
RUN update-alternatives --set vi /usr/bin/nvim
RUN update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
RUN update-alternatives --set vim /usr/bin/nvim
RUN update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
RUN update-alternatives --set editor /usr/bin/nvim

WORKDIR /
COPY os .

# vim配置文件在上面的仓库里面，所以这一行必须放到之后执行
RUN curl -fLo /usr/share/nvim/runtime/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim +PlugInstall +qall
RUN tldr --update
RUN updatedb
RUN chsh -s /usr/bin/zsh root
RUN mv /root /root.init
USER root

CMD ["/etc/rc.local"]
