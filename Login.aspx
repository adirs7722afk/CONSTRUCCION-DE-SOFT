<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="PlataformaEducativa.Login" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login - Institución Santo Tomás Aquino Circa - Arequipa</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #004d99, #00aaff);
            margin: 0;
            padding: 0;
        }
        .login-container {
            width: 400px;
            margin: 80px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0px 6px 20px rgba(0,0,0,0.2);
            text-align: center;
        }
        h2 {
            margin-bottom: 20px;
            color: #004d99;
        }
        .institucion {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
            font-style: italic;
        }
        .textbox {
            width: 90%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        .btn {
            width: 95%;
            padding: 12px;
            background: #004d99;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        .btn:hover {
            background: #0066cc;
        }
        .mensaje {
            margin-top: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <h2>Iniciar Sesión</h2>
            <div class="institucion">
                Institución Santo Tomás Aquino<br />Circa - Arequipa
            </div>

            <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" Placeholder="Correo electrónico"></asp:TextBox><br />
            <asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" Placeholder="Contraseña" TextMode="Password"></asp:TextBox><br />
            
            <asp:Button ID="btnLogin" runat="server" Text="Ingresar" CssClass="btn" OnClick="btnLogin_Click" /><br />
            
            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>
