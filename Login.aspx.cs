using System;
using System.Configuration;
using System.Data.SqlClient;

namespace PlataformaEducativa
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear(); // limpiar sesión al cargar login
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["EduConnection"].ConnectionString))
            {
                string query = "SELECT Id, Nombre, Rol FROM Usuarios WHERE Email=@Email AND Password=@Password";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    // Guardar sesión
                    Session["UsuarioId"] = dr["Id"].ToString();
                    Session["Nombre"] = dr["Nombre"].ToString();
                    Session["Rol"] = dr["Rol"].ToString();

                    string rol = dr["Rol"].ToString();
                    if (rol == "Admin")
                        Response.Redirect("~/PANELES/PanelAdmin.aspx");
                    else if (rol == "Docente")
                        Response.Redirect("~/PANELES/PanelDocente.aspx");
                    else if (rol == "Estudiante")
                        Response.Redirect("~/PANELES/PanelEstudiante.aspx");
                    else if (rol == "Padre")
                        Response.Redirect("~/PANELES/PanelPadre.aspx");
                }
                else
                {
                    lblMensaje.Text = "❌ Credenciales incorrectas.";
                }
            }
        }
    }
}
