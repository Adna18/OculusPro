using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.OpenApi.Models;
using OftamoloskaOrdinacija.Filters;
using OftamoloskaOrdinacija.Model.Requests;
using OftamoloskaOrdinacija.Model.SearchObjects;
using OftamoloskaOrdinacija.Services;
using OftamoloskaOrdinacija.Services.Database;
using OftamoloskaOrdinacija.Services.ProizvodiStateMachine;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;

namespace OftamoloskaOrdinacija
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddTransient<IProizvodiService, ProizvodiService>();
            builder.Services.AddTransient<IKorisniciService, KorisniciService>();
            builder.Services.AddTransient<IService<OftamoloskaOrdinacija.Model.VrstaProizvodum, BaseSearchObject>,
            BaseService<OftamoloskaOrdinacija.Model.VrstaProizvodum,OftamoloskaOrdinacija.Services.Database.VrstaProizvodum,BaseSearchObject>>();
            builder.Services.AddTransient<IDojamService, DojamService>();
            builder.Services.AddTransient<IRecenzijaService, RecenzijaService>();
            builder.Services.AddTransient<INarudzbaService, NarudzbaService>();
            builder.Services.AddTransient<INovostiService, NovostiService>();
            builder.Services.AddTransient<IZdravstveniKartonService, ZdravstveniKartonService>();
            builder.Services.AddTransient<ITerminService, TerminService>();
            builder.Services.AddTransient<IOmiljeniProizvodiService, OmiljeniProizvodiService>();
            builder.Services.AddTransient<ITransakcijaService, TransakcijaService>();
            builder.Services.AddTransient<IStavkaNarudzbeService, StavkaNarudzbeService>();
            builder.Services.AddTransient<IRecommendResultService, RecommendResultService>();




            builder.Services.AddTransient<BaseState>();
            builder.Services.AddTransient<InitialProductState>();
            builder.Services.AddTransient<DraftProductState>();
            builder.Services.AddTransient<ActiveProductState>();

            builder.Services.AddHttpContextAccessor();

            builder.Services.AddControllers(x =>
            {
                x.Filters.Add<ErrorFilter>();
            });

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();

            builder.Services.AddSwaggerGen(c =>
            {
                c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
                {
                    Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
                    Scheme = "basic"
                });

                c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[]{}
        }
    });
            });



            var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
            builder.Services.AddDbContext<OftamoloskiCentarContext>(options =>
                options.UseSqlServer(connectionString));

            builder.Services.AddAutoMapper(typeof(IKorisniciService));
            builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);



            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();
            app.UseAuthentication();
            app.UseAuthorization();


            app.MapControllers();


            using (var scope = app.Services.CreateScope())
            {
                var dataContext = scope.ServiceProvider.GetRequiredService<OftamoloskiCentarContext>();

                var databaseExist = dataContext.Database.GetService<IRelationalDatabaseCreator>().Exists();

                if (!databaseExist)
                {
                    dataContext.Database.Migrate();

                    var recommendResutService = scope.ServiceProvider.GetRequiredService<IRecommendResultService>();
                    try
                    {
                        recommendResutService.TrainProductsModel();
                    }
                    catch (Exception e)
                    {
                    }
                }
            }

            string hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ";
            string username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
            string password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
            string virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";


            ////////////////////////////////////////////////////////////////////////////////////

            var factory = new ConnectionFactory
            {
                HostName = hostname,
                UserName = username,
                Password = password,
                VirtualHost = virtualHost,
            };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "favorites",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: true,
                                 arguments: null);

            Console.WriteLine(" [*] Waiting for messages.");

            var consumer = new EventingBasicConsumer(channel);
            consumer.Received += async (model, ea) =>
            {
                var body = ea.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);
                Console.WriteLine(message.ToString());
                var omiljeni = JsonSerializer.Deserialize<OmiljeniProizvodiUpsertRequest>(message);
                using (var scope = app.Services.CreateScope())
                {
                    var omiljeniProizvodiService = scope.ServiceProvider.GetRequiredService<IOmiljeniProizvodiService>();

                    if (omiljeni != null)
                    {
                        try
                        {
                            await omiljeniProizvodiService.Insert(omiljeni);
                        }
                        catch (Exception e)
                        {

                        }
                    }
                }
                // Console.WriteLine();
                Console.WriteLine(Environment.GetEnvironmentVariable("Some"));
            };
            channel.BasicConsume(queue: "favorites",
                                 autoAck: true,
                                 consumer: consumer);


            //////////////////////////////////////////////////////////////////////////////////
            ///

            app.Run();
        }
    }
}
