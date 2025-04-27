+++
title =  "Comments for static pages? - Part 2"
[taxonomies]
tags = ["tech", "jekyll"]
+++

Looking [back]({{< relref "comments-on-jekyll" >}})... I need a bit of DIY GitHub API for Rust.

## Still step 2: Create a branch and PR automatically


Thankfully, the [V3 API](https://developer.github.com/v3/) is really simple.

Using our tRusty language, we can define some structs to be serialized to JSON for requests:
```rust
#[derive(Serialize)]
struct CreateRef {
    r#ref: String, // The name to be used
    sha: String,   // The commit SHA to point to
}

#[derive(Serialize)]
struct CreateFile {
    message: String,
    content: String,
    branch: String,
    committer: UserRef,
}

#[derive(Serialize)]
struct UserRef {
    name: String,
    email: String,
}

#[derive(Serialize)]
struct CreatePR {
    title: String,
    head: String,   // The branch to be merged
    base: String,   // The target branch for the merge (ie. master)
}
```

The basic steps we want to do are described by these:
* Create a branch, using `CreateRef`. Git uses refs for things that "have" commits. A branch is just that!
* Create a file on the branch with `CreateFile`. `UserRef` will be used as committer (me in this case).
* The last step is to create a PR with `CreatePR`  (quelle surprise), to merge the branch back.

The file we want to create has to be converted to base64 to be used by `CreateFile`. The content itself should be YAML and contain this:
```rust
#[derive(Serialize)]
struct Comment {
    id: String,
    r#ref: String,
    message: String,
    name: String,
    url: String,
    date: u64,
}
```

Luckily [serde](https://serde.rs/) comes to our rescue once again and happily creates a serializer to yaml here.
Another helpful small library provides base64 encoding. The result is this:
```rust
let file = CreateFile {
    message: "Comment".to_string(),
    content: encode(&serde_yaml::to_string(&comment).unwrap()),
    branch: branch_name.to_string(),
    committer: UserRef {
        name: owner.to_string(),
        email: owner_email.to_string(),
    },
};
```

The requests itself look quite similar. As an example, here's the `CreateFile` one:
```rust
fn create_file(
    client: &reqwest::blocking::Client,
    owner: &str,
    repo: &str,
    path: &str,
    create_file: &CreateFile,
) -> reqwest::Result<reqwest::blocking::Response> {
    let url = url::Url::parse(
        format!(
            "https://api.github.com/repos/{}/{}/contents/{}",
            owner, repo, path
        )
        .as_str(),
    )
    .unwrap();
    client.put(url).json(create_file).send()
}
```

No, `reqwest` is not a typo! It's actually a [popular library](https://github.com/seanmonstar/reqwest) (I don't mean the javascript one).
I don't really need non-blocking I/O here, so the `blocking` client is put to good use.

The whole Rust project can be found [in my GitHub repo](https://github.com/Bytekeeper/github_comment_rs).

I tried to solve this "problem" with some constraints: 
* It should be inexpensive
* It should respect the privacy of my readers
* It should be simple enough to fix or port
* It should not depend too much on third parties

Using GitHub for the blog and for comments is very inexpensive. I use no third party commentary service, as such the privacy is protected as much as is possible here.
The HTML part is very simple and only depends on [Jekyll](https://jekyllrb.com/). The Rust part is also simple and fits in less than 300 lines of code of Rust.

Success &#10003;

If you have any comments, please leave them down below - since you are actually able to do so now!
