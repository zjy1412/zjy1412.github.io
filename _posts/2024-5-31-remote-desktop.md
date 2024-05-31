---
layout: post
title:  "使用frp中继rdp来进行远程控制电脑"
categories: Remote Desktop
tags:  Remote Desktop RustDesk frp rdp
author: zjy1412
---

* content
{:toc}
因为在宿舍使用台式电脑，在外面只能使用笔记本，所以远程使用电脑对我来说是刚需。原先我是使用Todesk的免费版的，虽然帧数和画质不高，但是延迟很低，也足够用了。

但是就在5月底，Todesk的免费版悄无声息地加上了限制：200小时和300次使用。这对我来说绝对是不够用的，也就是在逼我订阅专业版（没有说商家不好的意思）。我决定转换阵营，在网上搜索一番后，我选择了frp中继rdp的方案。





## RustDesk

其实一开始我是找到了这样一款开源的软件的，然后打算以自建服务器的方式来完成远程连接。但是因为服务器在新加坡，在实现完后发现延迟平均在100ms以上，而且掉帧严重。同时它原先支持p2p的，但是不知道为什么校园网使用不了这个模式。

所以，我很快就放弃了这个方案。（我是根据[这个]("https://www.bilibili.com/video/BV148411i7DR/?vd_source=fadd5bcea8cb448ccdf656ba78ddb1d4#reply223912234016")进行配置的。）

## frp中继rdp

后来在一位评论区老哥那里发现了另一种方案——frp中继rdp。

使用 FRP 中继 RDP 指的是使用 FRP（Fast Reverse Proxy）软件来转发或中继远程桌面协议（RDP）连接。这种方法通常用于穿透NAT（网络地址转换）和防火墙，使外部网络的设备能够安全地连接到内网中的远程桌面，即使远程桌面位于使用私有IP地址的内网中也能够实现。

### FRP（Fast Reverse Proxy）

**FRP** 是一个高性能的反向代理应用程序，可以帮助内网服务通过简单的配置，安全地暴露到外网环境。它主要用于以下场景：

- 内网穿透
- 安全地暴露内网服务
- 跨越网络边界访问服务

FRP 支持多种协议，包括 TCP、UDP、HTTP、HTTPS 等。

### RDP（Remote Desktop Protocol）

**RDP** 是由微软开发的一种协议，允许用户通过网络连接到另一台计算机上，并在远程计算机上进行操作，就如同坐在那台计算机前一样。它广泛应用于远程工作和服务器管理。

### 如何用 FRP 中继 RDP

使用 FRP 来中继 RDP 连接通常包括以下步骤：

1. **配置 FRP 服务器（frps）**：在一台具有公网IP地址的服务器上部署 FRP 服务器端（frps）。这台服务器将接收来自 Internet 的连接请求。

2. **配置 FRP 客户端（frpc）**：在需要远程访问的内网机器上配置 FRP 客户端（frpc）。这个配置指定了要转发的内网服务（在这里是 RDP），以及 frps 服务器的地址。

3. **连接到 RDP**：外部用户通过指向 FRP 服务器的特定端口（在 frpc 配置中指定）来启动 RDP 会话，FRP 服务器将请求转发到内网的远程桌面服务。

这样设置的好处是可以绕过 NAT 和防火墙限制，同时保持连接的安全性，因为可以在 FRP 通道上使用加密。此外，这种方法不需要在路由器上设置复杂的端口转发规则，配置和维护起来较为简单和灵活。

### 具体做法

要使用 FRP (Fast Reverse Proxy) 中继 RDP (Remote Desktop Protocol)，你需要在具有公网 IP 地址的服务器上设置 FRP 服务器 (frps)，并在需要远程访问的内网机器上设置 FRP 客户端 (frpc)。下面是具体步骤和配置示例。

#### 步骤 1: 配置 FRP 服务器 (frps)

1. **获取和安装 FRP**:
   - 从 [FRP GitHub](https://github.com/fatedier/frp/releases) 页面下载最新的 frps 版本到你的服务器。
   - 解压下载的文件包。

2. **创建 FRP 服务器配置文件** (`frps.ini`):
   - 在服务器上创建一个配置文件 `frps.ini`。（这里的`ini`的文件格式有点过时，你可以选择使用更新的格式）
   - 添加以下内容作为配置示例：
     ```ini
     [common]
     bind_port = 7000
     ```

3. **启动 FRP 服务器**:
   - 在包含 `frps.ini` 的目录中运行：
     ```bash
     ./frps -c frps.ini
     ```

#### 步骤 2: 配置 FRP 客户端 (frpc)

1. **在内网机器上安装 FRP 客户端**:
   - 同样从 FRP 的 GitHub 页面下载 frpc 的最新版本。
   - 解压下载的文件包。

2. **创建 FRP 客户端配置文件** (`frpc.ini`):
   - 在客户端机器上创建一个配置文件 `frpc.ini`。
   - 添加以下内容作为配置示例，其中 `server_addr` 是 FRP 服务器的公网 IP 地址或域名：
     ```ini
     [common]
     server_addr = x.x.x.x
     server_port = 7000

     [rdp]
     type = tcp
     local_ip = 127.0.0.1
     local_port = 3389
     remote_port = 6000
     ```

   这里，`local_ip` 和 `local_port` 指向内网机器上的 RDP 服务，通常端口为 3389。`remote_port` 是在公网服务器上开放的端口，外部客户端将通过这个端口连接。

3. **启动 FRP 客户端**:
   - 在包含 `frpc.ini` 的目录中运行：
     ```bash
     ./frpc -c frpc.ini
     ```

#### 步骤 3: 远程连接

- 现在，外部用户可以使用远程桌面客户端（如 Microsoft Remote Desktop）连接到 `x.x.x.x:6000`，其中 `x.x.x.x` 是 FRP 服务器的公网 IP 地址，`6000` 是在 `frpc.ini` 中配置的 `remote_port`。
- 这个连接会通过 FRP 服务器转发到内网的 RDP 服务。

确保服务器的防火墙和安全组允许相应的端口（在这个例子中是 7000 和 6000）接受入站和出站连接。另外我使用的就是Microsoft Remote Desktop，要注意两边的电脑都有开启`Remote Desktop`。

这样设置后，你就可以从任何地方通过 FRP 服务器安全地连接到内网的远程桌面，即使它位于 NAT 或防火墙后面也没有问题。