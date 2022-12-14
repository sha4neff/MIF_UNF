#Область ПрограммныйИнтерфейс

Функция НастройкиПоУмолчанию(АдресЭлектроннойПочты, Пароль) Экспорт
	
	Позиция = СтрНайти(АдресЭлектроннойПочты, "@");
	ИмяСервераВУчетнойЗаписи = Сред(АдресЭлектроннойПочты, Позиция + 1);
	
	Настройки = Новый Структура;
	
	Настройки.Вставить("ИмяПользователяДляПолученияПисем", АдресЭлектроннойПочты);
	Настройки.Вставить("ИмяПользователяДляОтправкиПисем", АдресЭлектроннойПочты);
	
	Настройки.Вставить("ПарольДляОтправкиПисем", Пароль);
	Настройки.Вставить("ПарольДляПолученияПисем", Пароль);
	
	Настройки.Вставить("Протокол", "IMAP");
	Настройки.Вставить("СерверВходящейПочты", "imap." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераВходящейПочты", 993);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляВходящейПочты", Истина);
	
	Настройки.Вставить("СерверИсходящейПочты", "smtp." + ИмяСервераВУчетнойЗаписи);
	Настройки.Вставить("ПортСервераИсходящейПочты", 465);
	Настройки.Вставить("ИспользоватьЗащищенноеСоединениеДляИсходящейПочты", Истина);
	Настройки.Вставить("ТребуетсяВходНаСерверПередОтправкой", Ложь);
	
	Настройки.Вставить("ДлительностьОжиданияСервера", 30);
	Настройки.Вставить("ОставлятьКопииПисемНаСервере", Истина);
	Настройки.Вставить("УдалятьПисьмаССервераЧерез", 0);
	
	Возврат Настройки;
	
КонецФункции

Функция РежимЗагрузкиНовыеСообщения() Экспорт
	
	Возврат "РежимЗагрузкиНовыеСообщения";
	
КонецФункции

Функция РежимЗагрузкиПредыдущиеСообщения() Экспорт
	
	Возврат "РежимЗагрузкиПредыдущиеСообщения";
	
КонецФункции

Функция КомандаОтветить() Экспорт
	
	Возврат "КомандаОтветить";
	
КонецФункции

Функция КомандаПереслать() Экспорт
	
	Возврат "КомандаПереслать";
	
КонецФункции

Функция ИмяСобытияУчетнаяЗаписьОбновлена() Экспорт
	
	Возврат "УчетнаяЗаписьОбновлена";
	
КонецФункции

Функция ИмяСобытияИзмененСоставПодключенныхУчетныхЗаписей() Экспорт
	
	Возврат "ИзмененСоставПодключенныхУчетныхЗаписей";
	
КонецФункции

Функция ИмяСобытияУчетнаяЗаписьЗаписана() Экспорт
	
	Возврат "Запись_УчетнаяЗаписьЭлектроннойПочты"
	
КонецФункции

// Удаляет угловые скобки (<>) с начала и конца строки, если они есть.
//
// Параметры:
//  Строка - входная строка;
//
// Возвращаемое значение:
//  Строка - строка без угловых скобок (<>).
// 
Функция СократитьУгловыеСкобки(Знач Строка) Экспорт
	
	Пока СтрНачинаетсяС(Строка, "<") Цикл
		Строка = Сред(Строка, 2);
	КонецЦикла; 
	
	Пока СтрЗаканчиваетсяНа(Строка, ">") Цикл
		Строка = Лев(Строка, СтрДлина(Строка) - 1);
	КонецЦикла;
	
	Возврат Строка;
	
КонецФункции

Функция МаксимальноеКоличествоПакетноСопоставляемыхАдресов() Экспорт
	
	Возврат 1000;
	
КонецФункции

#КонецОбласти