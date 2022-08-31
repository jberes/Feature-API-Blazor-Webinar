using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace FeaturesApi.Models
{
    public partial class FeaturesContext : DbContext
    {
        public FeaturesContext()
        {
        }

        public FeaturesContext(DbContextOptions<FeaturesContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Feature> Features { get; set; } = null!;
        public virtual DbSet<Product> Products { get; set; } = null!;
        public virtual DbSet<VwFeatureProduct> VwFeatureProducts { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Name=ConnectionStrings:LocalConnection");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Feature>(entity =>
            {
                entity.Property(e => e.DateAdded)
                    .HasColumnType("date")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Description)
                    .HasMaxLength(500)
                    .IsUnicode(false);

                entity.Property(e => e.ProductId).HasDefaultValueSql("((1))");

                entity.Property(e => e.RequestorEmail)
                    .HasMaxLength(75)
                    .IsUnicode(false);

                entity.Property(e => e.Title)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Product>(entity =>
            {
                entity.Property(e => e.Product1)
                    .HasMaxLength(75)
                    .IsUnicode(false)
                    .HasColumnName("Product");
            });

            modelBuilder.Entity<VwFeatureProduct>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("vw_FeatureProducts");

                entity.Property(e => e.DateAdded).HasColumnType("date");

                entity.Property(e => e.Description)
                    .HasMaxLength(500)
                    .IsUnicode(false);

                entity.Property(e => e.Product)
                    .HasMaxLength(75)
                    .IsUnicode(false);

                entity.Property(e => e.RequestorEmail)
                    .HasMaxLength(75)
                    .IsUnicode(false);

                entity.Property(e => e.Title)
                    .HasMaxLength(100)
                    .IsUnicode(false);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
