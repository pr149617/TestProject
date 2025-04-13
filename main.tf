provider "google" {
    
    project = "lateral-boulder-455508-r2"
    credentials = file("D:/Knowledge/terraform/Terraform_jenkins/jenkinsvacckey.json")
    
  
}
resource "google_compute_network" "TestVPC" {
   
   name= "customvpc"
   auto_create_subnetworks = false
   description = "customPVC for creation"
    
  
}
resource "google_compute_subnetwork" "testsubnet" {

   name          = "test-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.TestVPC.id
  
}
resource "google_compute_instance" "TestVM" {

  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"
  boot_disk {
     initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
     subnetwork = google_compute_subnetwork.testsubnet.id
  }

  
}