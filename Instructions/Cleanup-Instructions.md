# Cleaning up Resources Created

---

<details>

<summary>Clean up all resources</summary>

> This will remove every resource created by the scripts and by Terraform. Project and storage bucket used to store terraform state will be removed.

```
> make clear_resources
```

_If you delete project and bucket, defaults need to be updated. Edit `scripts/default-values.sh` or specify their values when running `scripts/tf-create.sh`_

</details>

---

<details>

<summary>Clean up resources created by Terraform only</summary>

```
> cd terraform-config
> terraform destroy --auto-approve
```

This will not remove project and storage bucket created by the script. Does not force creation of new GCP project and storage bucket used to store terraform state

</details>
