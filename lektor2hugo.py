import json
import os
import shutil


for dirpath, dirnames, filenames in os.walk("_old/content/blog"):
    for filename in filenames:
        file_path = os.path.join(dirpath, filename)
        if filename.endswith(".lr"):
            # read file contents into file_contents variable
            with open(file_path, "r") as file:
                file_contents = file.read()

            attributes = {}
            attrs = file_contents.split("---\n")

            for attr in attrs:
                if not attr.strip():
                    continue
                key, value = attr.split(":", 1)
                attributes[key.strip()] = value.strip()

            if attributes.get("_model", "blog-post") != "blog-post":
                continue

            # convert slug to path
            year, month, day, slug = (
                file_path.replace("_old/content/blog/", "")
                .replace("/contents.lr", "")
                .split("-", 3)
            )
            os.makedirs(f"content/blog/{year}/{month}/{day}/{slug}", exist_ok=True)

            if not os.path.exists(f"content/blog/{year}/{month}/{day}/{slug}/index.md"):
                with open(
                    os.path.join(f"content/blog/{year}/{month}/{day}/{slug}/index.md"),
                    "w",
                ) as handler:
                    handler.write("+++\n")
                    for key, value in attributes.items():
                        if key == "pub_date":
                            handler.write(f"date = {value.strip()}\n")
                            continue

                        if key == "tags":
                            tagContent = [tag.strip() for tag in value.split(",")]
                            handler.write(f"tags = [")
                            for tag in tagContent:
                                if tagContent.index(tag) == len(tagContent) - 1:
                                    handler.write(f'"{tag.strip()}"')
                                else:
                                    handler.write(f'"{tag.strip()}", ')
                            handler.write("]\n")
                            continue

                        if key != "body" and not key.startswith("_"):
                            handler.write(f'{key.strip()} = "{value.strip()}"\n')
                    handler.write("+++\n\n")
                    handler.write(attributes["body"])
            continue

        try:
            year, month, day, slug = (
                file_path.replace("_old/content/blog/", "")
                .replace("/contents.lr", "")
                .split("-", 3)
            )

            print(f"Processing {os.path.join(dirpath, filename)}...")

            if not os.path.exists(f"content/blog/{year}/{month}/{day}/{slug}"):
                print(f"Creating content/blog/{year}/{month}/{day}/{slug}...")
                shutil.copy2(
                    os.path.join(dirpath, filename),
                    f"content/blog/{year}/{month}/{day}/{slug}",
                )

        except Exception as err:
            print(err)
            continue
