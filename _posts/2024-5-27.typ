---
layout: post
title:  "Lab 0 实验准备"
categories: website
tags:  website github
author: zjy1412
---

* content
{:toc}

#import "./base/templates/report.typ": *

#show: report.with(
  title: "本科生实验报告",
  subtitle: "Lab 0 实验准备",
  name: "郑家耀",
  stdid: "22331128",
  classid: "实验一班",
  major: "计算机科学与技术",
  school: "计算机学院",
  time: "2023~2024 学年第二学期",
  banner: "../images/sysu.png"
)

= 实验要求

- 配置好实验环境，熟悉实验环境的使用方法。

- 尝试使用rust进行编程，熟悉rust的基本语法。

- 运行UEFI Shell，熟悉UEFI Shell的基本命令。

- 启动YSOS

= 实验过程

== 实验环境配置
我选择使用虚拟机进行实验，虚拟机的系统为Ubuntu 22.04，与推荐实验环境一致。我在虚拟机中更新了apt源并进行软件升级，然后安装了qemu，rustup，vscode等实验所需的环境，同时完成了相关的验证工作。

== Rust编程

- 实现了一系列函数: count_down, read_and_print, file_size， 并且调用它们进行了测试，得到了预期的输出。

- 实现了一个进行字节数转换的函数， 并通过了测试。

- 使用现有的crate在终端中输出彩色的文字。

- 利用enum类型实现了一个名为Shape的枚举类型，其中包含了Circle和Rectangle两种类型， 并且实现了一个计算面积的函数，其通过了测试。

- 实现了UniqueID类型， 并且通过了测试。

== UEFI Shell

我使用git clone命令下载了所需的仓库，并且借助其初始化了自己的仓库，其中文件完整。接着在简单了解UEFI Shell的功能后，使用命令启动UEFI Shell，其输出与预期一致。

== YSOS

根据仓库提供的.toml文件指定的Rust工具链，在项目根目录下运行make run命令，得到输出与预期一致，成功启动了YSOS。

= 关键代码

== Rust编程

编程任务1：
```rust
// 创建一个函数进行倒计时
fn count_down(seconds: u64) {
    for i in (1..=seconds).rev() {
        println!("Remaining seconds: {}", i);
        std::thread::sleep(std::time::Duration::from_secs(1));// 这行代码的作用是让当前线程休眠一秒钟。
    }
    println!("Countdown finished!");
}

// 创建一个函数尝试读取并输出文件的内容
fn read_and_print(file_path: &str) {
    match File::open(file_path) {
        Ok(mut file) => {
            let mut contents = String::new();
            file.read_to_string(&mut contents).expect("Failed to read file");
            println!("{}", contents);
        }
        Err(_) => {
            panic!("File not found!");
        }
    }
}

// 创建一个函数尝试获取文件大小，并处理可能的错误
fn file_size(file_path: &str) -> Result<u64, &str> {
    match std::fs::metadata(file_path) {
        Ok(metadata) => Ok(metadata.len()),
        Err(_) => Err("File not found!"),
    }
}
```

编程任务2：
```rust
fn humanized_size(size: u64) -> (f64, &'static str) {
    const KIB: f64 = 1024.0;
    const MIB: f64 = KIB * KIB;
    const GIB: f64 = KIB * MIB;

    if size < KIB as u64 {
        (size as f64, "B")
    } else if size < MIB as u64 {
        (size as f64 / KIB, "KiB")
    } else if size < GIB as u64 {
        (size as f64 / MIB, "MiB")
    } else {
        (size as f64 / GIB, "GiB")
    }
}
```

编程任务3：
```rust
use colored::Colorize;

fn main() {
    // 输出绿色的 INFO
    println!("{} Hello, world!", "INFO:".green());

    // 输出黄色、加粗、下划线的 WARNING
    println!("{}", "WARNING: I'm a teapot!".yellow().bold().underline());

    // 输出红色、加粗的 ERROR，并尝试在控制台窗口居中
    let error_message = "KERNEL PANIC!!!";
    let padding = (80 - error_message.len()) / 2;
    println!("{:-^80}", "");  // 打印横线，用于居中
    println!("{:width$}{}", "", error_message.red().bold(), width = padding);
    println!("{:-^80}", "");  // 打印横线，用于居中
}
```

编程任务4：
```rust
use std::f64::consts::PI;

enum Shape {
    Rectangle { width: f64, height: f64 },
    Circle { radius: f64 },
}

impl Shape {
    pub fn area(&self) -> f64 {
        match self {
            Shape::Rectangle { width, height } => width * height,
            Shape::Circle { radius } => PI * radius * radius,
        }
    }
}
```

编程任务5：
```rust
struct UniqueId(u16);

impl UniqueId {
    fn new() -> UniqueId {
        static mut NEXT_ID: u16 = 0;

        unsafe {
            let id = NEXT_ID;
            NEXT_ID += 1;
            UniqueId(id)
        }
    }
}
```

= 实验结果

== 实验环境配置

版本与实验推荐一致
#image("/images/rust_check.png")

== Rust编程

编程任务1：
#image("/images/rust1.png")

编程任务2：
#image("/images/rust2.png")

编程任务3：
#image("/images/rust3.png")

编程任务4：
#image("/images/rust4.png")

编程任务5：
#image("/images/rust5.png")

== UEFI Shell

校验文件完整性：
#image("/images/UEFI_check.png")

使用QEMU启动UEFI Shell：
#image("/images/UEFI_shell_open.png")

== YSOS

YSOS启动：
#image("/images/YSOS_running.png")

= 实验总结
在这个实验中，我首先配置了实验环境，确保所需的工具和库已经安装，并且进行了相关的验证工作。随后，我使用 Rust 进行编程，实现了一系列任务，包括倒计时、文件操作、字节数转换、彩色输出、枚举类型实现面积计算、以及唯一标识生成。在编程过程中，我熟悉了 Rust 的基本语法和一些常见的文件和系统操作。

在实现彩色输出时，我使用了 colored crate 来实现不同颜色的文字输出，通过这个过程我了解了如何在终端中添加颜色和样式。

在 UEFI Shell 的部分，我克隆了仓库，通过简单的命令了解了 UEFI Shell 的基本功能，并启动了 YSOS 系统，验证了环境配置的正确性。

= 思考题&加分项
== 了解现代操作系统（Windows）的启动过程，UEFI 和 Legacy（BIOS）的区别是什么？
答：UEFI 是一种新型的固件接口，它是 BIOS 的替代品。UEFI 与传统的 BIOS 相比，具有启动速度快、支持大容量硬盘、支持多分区启动、支持网络启动、支持图形界面等优点。UEFI 启动过程中，会加载 UEFI Shell，然后通过 UEFI Shell 加载操作系统内核。而传统的 BIOS 启动过程中，会加载 MBR，然后通过 MBR 加载操作系统内核。

== 尝试解释 Makefile 中的命令做了哪些事情？
答：
- run: 构建项目并启动 QEMU 虚拟机运行UEFI程序。
- launch：启动 QEMU 虚拟机运行UEFI程序。
- intdbg：启动 QEMU 虚拟机并启用 GDB 调试。
- debug：启动 QEMU 虚拟机并启用 GDB 调试。
- clean：清理项目构建产物。
- build：构建项目。

== 利用 cargo 的包管理和 docs.rs 的文档，我们可以很方便的使用第三方库。这些库的源代码在哪里？它们是什么时候被编译的？
答：这些库的源代码通常托管在版本控制系统。而它们是在我们使用 cargo build 或 cargo run 命令时被编译的。

== 为什么我们需要使用 \#\[entry\] 而不是直接使用 main 函数作为程序的入口？
答：使用 \#\[entry\] 而不是 main 是为了适应裸机和嵌入式环境的特殊需求，让程序入口更加灵活。

== 基于控制行颜色的 Rust 编程题目，参考 log crate 的文档，为不同的日志级别输出不同的颜色效果，并进行测试输出。
答：日志包括 Fatal, Error, Warn, Info, Debug, Trace 等级别，我选择其中的 Info，Warn，Error 三个级别进行测试。

```rust
use colored::*;
use log::{info, warn, error};// 已在toml里添加log依赖

fn main() {
    env_logger::init();

    // 记录不同级别的日志并应用颜色效果
    info!("{} This is an info message.", "INFO:".green());
    warn!("{} This is a warning message.", "WARNING:".yellow().bold().underline());
    error!("{} This is an error message.", "ERROR:".red().bold());
}
```
输出展示：
#image("/images/log&color.png")

== 基于第一个 Rust 编程题目，实现一个简单的 shell 程序
答：
关键代码：
```rust
fn cd_command(target: &str) {
    let current_dir = env::current_dir().expect("Failed to get current directory");
    let mut new_path = current_dir;

    for component in target.split('/') {
        if component == ".." {
            new_path.pop();
        } else {
            new_path.push(component);
        }
    }

    env::set_current_dir(&new_path).expect("Failed to change directory");
}

fn ls_command() {
    let current_dir = env::current_dir().expect("Failed to get current directory");
    let entries = current_dir.read_dir().expect("Failed to read directory entries");

    for entry in entries {
        if let Ok(entry) = entry {
            let path = entry.path();
            let metadata = entry.metadata().unwrap();

            println!(
                "{}\t{:>10} bytes\tCreated: {:?}",
                path.display(),
                metadata.len(),
                metadata.created().unwrap()
            );
        }
    }
}

fn cat_command(file_path: &str) {
    if let Ok(file) = File::open(file_path) {
        let reader = BufReader::new(file);

        for line in reader.lines() {
            if let Ok(line) = line {
                println!("{}", line);
            }
        }
    } else {
        eprintln!("Error: Failed to open file '{}'", file_path);
    }
}
```

输出展示：
#image("/images/shell_simplified.png")

== 尝试使用线程模型，基于 UniqueId 的任务

在 Rust 中，使用 static mut 变量在多线程环境下是不安全的，因为多个线程可能同时访问和修改这个变量，导致数据竞争。

而AtomicU16 是一个用于原子操作的无符号 16 位整数类型。在多线程编程中，原子类型是为了避免数据竞争而设计的，提供了一组原子性的操作，确保在多线程环境中进行安全的共享数据修改。

unsafe：它的诞生主要是因为Rust的静态检查太强了，也有一部分是因为计算机底层的一些硬件本身就是不安全的，比如说指针操作，内存操作等等。unsafe的作用就是告诉编译器，这里的代码我知道是不安全的，但是我保证这里的代码是安全的，你不用检查了。

当然，它本身就如它的名字一样是不安全的，所以在使用的时候一定要小心，不要滥用。