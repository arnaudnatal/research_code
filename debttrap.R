library(ggplot2)

# Données
x <- seq(0, 12, length.out = 500)

df <- data.frame(
  x = x,
  y_line = x,
  y_sig = 1 + 10/(1 + exp(-2*(x - 6)))
)

# Points repères
D_p  <- 1
OI   <- 8
D_m  <- 6
D_c  <- 11

# Courbe convexe bleue
df_conv <- data.frame(
  x = seq(D_p, 12, length.out = 300)
)

df_conv$y_conv <- 1+0.0005*(df_conv$x-D_p)^4


# Courbe concave qui coupe la première bissectrice en D_c
df_conc <- data.frame(
  x = seq(0.5, 12, length.out = 300)
)

#df_conc$y_conc <- 11-0.2*(df_conc$x-7)^2
  

yDc <- 1 + 10/(1 + exp(-2*(D_c - 6)))  
df_conc$y_conc <- yDc -
  0.10 * (df_conc$x - 7)^2 +
  0.10 * (D_c - 7)^2




# Graphique
ggplot(df, aes(x = x)) +
  # Courbes
  geom_line(aes(y = y_sig), color = "red", linewidth = 1.2) +
  geom_line(aes(y = y_line), color = "black", linewidth = 1) +
  geom_line(data = df_conv, aes(x = x, y = y_conv),
            color = "blue", linewidth = 1.2, linetype = "dashed") +
  geom_line(data = df_conc, aes(x = x, y = y_conc),
            color = "purple", linewidth = 1.2) +
  
    
  # Lignes verticales
  geom_vline(xintercept = OI, color = "darkgreen", linewidth = 1) +
  geom_vline(xintercept = c(D_p, D_m, D_c),
             linetype = "dotted", color = "grey40") +
  
  # Axes dessinés
  geom_hline(yintercept = 0, color = "black", linewidth = 1) +
  geom_vline(xintercept = 0, color = "black", linewidth = 1) +
  
  # Limites
  coord_cartesian(xlim = c(0, 12), ylim = c(0, 12), clip = "off") +
  
  # Suppression complète des graduations
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  
  # Thème
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    plot.margin = margin(t = 10, r = 10, b = 40, l = 10)
  ) +
  
  # Labels axes
  labs(
    x = expression("Initial debt burden, " * D[t-1]),
    y = expression("Current debt burden, " * D[t])
  ) +
  
  # Annotations
  annotate("text", x = 3.5, y = 2,
           label = expression(g[3](D[t-1])),
           color = "red", size = 4) +
  annotate("text", x = 11, y = 4,
           label = expression(g[1](D[t-1])),
           color = "blue", size = 4) +
  annotate("text", x = 4, y = 11,
           label = expression(g[2](D[t-1])),
           color = "purple", size = 4) +
  annotate("text", x = 9.5, y = 10.5,
           label = expression(D[t+1] == D[t]),
           size = 4) +
  annotate("text", x = 7.2, y = 9.8,
           label = expression(H[1]), size = 4) +
  annotate("text", x = 5.2, y = 3.2,
           label = expression(H[2]), size = 4) +
  
  # Labels personnalisés sur l’axe x
  annotate("text", x = D_p+0.2, y = -0.5,
           label = expression(D[p]^"*"), size = 4) +
  annotate("text", x = OI+0.2, y = -0.5,
           label = expression(OI^"*"), size = 4) +
  annotate("text", x = D_m+0.2, y = -0.5,
           label = expression(D[m]), size = 4) +
  annotate("text", x = D_c+0.2, y = -0.5,
           label = expression(D[c]^"*"), size = 4)