abstract class loginevent {}

class loginSubmitted extends loginevent {
  String email, password;
  loginSubmitted(this.email, this.password);
}

class returnInitialStatus extends loginevent {}
