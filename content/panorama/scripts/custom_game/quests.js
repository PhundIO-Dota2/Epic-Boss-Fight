GameEvents.Subscribe( "updateQuestLife", UpdateLives);
GameEvents.Subscribe( "updateQuestPrepTime", UpdateTimer);
GameEvents.Subscribe( "updateQuestRound", UpdateRound);
GameEvents.Subscribe( "heroLoadIn", Initialize);
CustomNetTables.SubscribeNetTableListener( "hero_properties", UpdateCustomHud);



var ID = Players.GetLocalPlayer();
var playerHero = Players.GetPlayerSelectedHero(ID);

var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()

var newUI = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
var healthBar = dotaHud.FindChildTraverse("HealthContainer");


var shieldLabel = $.CreatePanel( "Label", $.GetContextPanel(), "ShieldLabel");
shieldLabel.SetParent(healthBar);
shieldLabel.AddClass("HealthContainerShieldLabel");

UpdateTooltipUI()
function UpdateTooltipUI(){
	var tooltips = dotaHud.FindChildTraverse("DOTAAbilityTooltip")
	if(tooltips != null){
		tooltips.FindChildTraverse("AbilityCosts").style.flowChildren = "down";
	} else {
		$.Schedule(0.1, UpdateTooltipUI);
	}
}


function UpdateCustomHud(playerHero){
	var index = Players.GetLocalPlayerPortraitUnit();
	var bReset = true
	var healthText = healthBar.FindChildTraverse("HealthLabel");
	if(index != null && Entities.IsHero( index )){
		var netTable = CustomNetTables.GetTableValue( "hero_properties", Entities.GetUnitName( index ) + index );
		if (netTable != null){
			if(netTable.barrier != null && netTable.barrier > 0){
				var barrier = netTable.barrier;
				shieldLabel.visible = true;
				healthText.style.visibility = "collapse";
				shieldLabel.text = healthText.text + " (" + barrier + ")";
				var pixelPct = Math.min(Math.max(barrier / Entities.GetMaxHealth(index) * 10, 2), 10);
				healthBar.style.boxShadow = "inset #c0c0c0aa " + pixelPct + "px " + pixelPct + "px " + pixelPct + "px " + (pixelPct*2) + "px";
				bReset = false
			}
		}
	}
	if(bReset){
		shieldLabel.visible = false;
		healthText.style.visibility = "visible";
		healthBar.style.boxShadow = "inset #c0c0c000 5px 5px 5px 10px";
	}
}


function Initialize(arg){
	var shop = dotaHud.FindChildTraverse("shop")    
	shop.RemoveClass("GuidesDisabled")
	var killCS = dotaHud.FindChildTraverse("quickstats");
	var newUI = dotaHud.FindChildTraverse("lower_hud");
	killCS.FindChildTraverse("QuickStatsContainer").style.visibility = "collapse";
	dotaHud.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
}

function UpdateLives(arg){
	$("#QuestLifeText").SetDialogVariableInt( "lives", arg.lives );
	$("#QuestLifeText").SetDialogVariableInt( "maxLives", arg.maxLives );
	$("#QuestLifeText").text =  $.Localize( "#QuestLifeText", $("#QuestLifeText") );
}

function UpdateTimer(arg){
	if( arg.prepTime > 0){	
		$("#QuestPrepText").visible =  true
		$("#QuestPrepText").SetDialogVariableInt( "prepTime", arg.prepTime );
		$("#QuestPrepText").text =  $.Localize( "#QuestPrepText", $("#QuestPrepText") );
	} else {
		$("#QuestPrepText").visible =  false
	}
}

function UpdateRound(arg){
	$("#QuestRoundText").visible =  true
	$("#QuestRoundText").SetDialogVariableInt( "roundNumber", arg.roundNumber );
	$("#QuestRoundText").SetDialogVariable( "roundText", $.Localize( arg.roundText ) );
	$("#QuestRoundText").text =  $.Localize( "#QuestRoundText", $("#QuestRoundText") );
}

function ReplaceIntWithToken(token){
	if(token == 1){
		return "#difficultyNormal"
	} else if(token == 2){
		return "#difficultyImpossible"
	} else if(token == 3){
		return "#difficultyPainful"
	} else if(token == 4){
		return "#difficultySadistic"
	} else if(token == 5){
		return "#difficultyOutrageous"
	}
}