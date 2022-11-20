
#Область HTTPМетоды

Функция FirstConnectionGet(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	ЦентральныйУзел = ПланыОбмена.СинхронизацияМП.ЭтотУзел();
	
	Если НЕ ЗначениеЗаполнено(ЦентральныйУзел.Код) Тогда
		Ответ.УстановитьТелоИзСтроки(СформироватьСтрокуОтправки(Новый Структура("НаличиеДанныхВЦБ", Ложь)));
	Иначе
		Ответ.УстановитьТелоИзСтроки(СформироватьСтрокуОтправки(Новый Структура("НаличиеДанныхВЦБ", Истина)));
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ConnectionGet(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	Возврат Ответ;
	
КонецФункции

Функция GetBaseIdGet(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ЦентральныйУзел = ПланыОбмена.СинхронизацияМП.ЭтотУзел();
	
	Ответ.УстановитьТелоИзСтроки(СформироватьСтрокуОтправки(Новый Структура("УникальныйИдентификаторЦентральнойБазы", ЦентральныйУзел.УникальныйИдентификатор())));
	
	Возврат Ответ;
	
КонецФункции

Функция GetBasicDataPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	ПроверитьНаличиеЦентральногоУзла();
	ПроверитьНаличиеКлиентскогоУзла(СтруктураЗапроса.КодКлиентскогоУзла, СтруктураЗапроса.НаименованиеКлиентскогоУзла);
	
	ВерсияСервера = СинхронизацияМПУНФ.ПолучитьТекущуюВерсиюПриложения();
	
	РегистрыСведений.СхемыКонфигурацийМП.ПроверитьНаличиеСхемы(ВерсияСервера);
	
	ИнформацияОВерсиях = ПолучитьИнформациюОВерсиях(ВерсияСервера, СтруктураЗапроса.ВерсияМобильногоПриложения);
	
	СтруктураОтвета = Новый Структура("ВерсияСервера, КодКлиентскогоУзла, НаименованиеКлиентскогоУзла, ИнформацияОВерсиях", ВерсияСервера, СтруктураЗапроса.КодКлиентскогоУзла, СтруктураЗапроса.НаименованиеКлиентскогоУзла, ИнформацияОВерсиях);
	СтрокаОтправки = СформироватьСтрокуОтправки(СтруктураОтвета);
	
	Ответ.УстановитьТелоИзСтроки(СтрокаОтправки);
	
	СтруктураЗаписи = Новый Структура("ФормированиеПакетовНаКлиенте, ФормированиеПакетовНаСервере, Узел, ВерсияБазыСКоторойИдетОбмен, СтатусСинхронизации", Перечисления.СтатусыФормированияПакетовМП.Запущено, Перечисления.СтатусыФормированияПакетовМП.Запущено, ПланыОбмена.СинхронизацияМП.НайтиПоКоду(СтруктураЗапроса.КодКлиентскогоУзла), СтруктураЗапроса.ВерсияМобильногоПриложения, Перечисления.СтатусыСинхронизацииМП.ОтправкаИПолучениеПакетов);
	РегистрыСведений.ЖурналСинхронизацииМП.ЗаписатьИнформацию(СтруктураЗаписи);
	
	ЗапуститьВыгрузкуВФоновомЗадании(СтруктураЗапроса.КодКлиентскогоУзла);
	
	РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.ИзменитьСтатусыСообщенийПриСтартеКонфигурации(СтруктураЗапроса.КодКлиентскогоУзла);
	
	Возврат Ответ;
	
КонецФункции

Функция ExchangePost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	ОбработатьЗапросКлиента(СтруктураЗапроса);
	
	СтрокаОтправки = СформироватьОтветДляКлиента(СтруктураЗапроса);
	Ответ.УстановитьТелоИзСтроки(СтрокаОтправки);
	
	Возврат Ответ;
	
КонецФункции

Функция SendXSDPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	НеобходимаяВерсия = Запрос.ПолучитьТелоКакСтроку();
	
	Схема = РегистрыСведений.СхемыКонфигурацийМП.ПолучитьСхему(НеобходимаяВерсия);
	
	СтруктураОтвета = Новый Структура("Схема", Схема);
	СтрокаОтправки = СформироватьСтрокуОтправки(СтруктураОтвета);
	
	Ответ.УстановитьТелоИзСтроки(СтрокаОтправки);
	
	Возврат Ответ;
	
КонецФункции

Функция DeleteMessagePost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	РегистрыСведений.СформированныеСообщенияДляОтправкиМП.УдалитьСообщение(СтруктураЗапроса.НомерСообщения, СтруктураЗапроса.КодКлиентскогоУзла);
	
	Возврат Ответ;
	
КонецФункции

Функция GetXSDPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	РегистрыСведений.СхемыКонфигурацийМП.ДобавитьСхему(СтруктураЗапроса.Схема,СтруктураЗапроса.ВерсияКлиента);
	
	Возврат Ответ;
	
КонецФункции

Функция CheckNewNumbersPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	КодУзла = Запрос.ПолучитьТелоКакСтроку();
	
	СтруктураОтвета = РегистрыСведений.СформированныеСообщенияСИзмененнымиНомерамиМПУНФ.ПолучитьСообщенияДляОтправки(КодУзла);
	
	ВсеПринятыеПакетыЗапущеныНаЗагрузку = ВсеПринятыеПакетыЗапущеныНаЗагрузку(КодУзла);
	
	Если НЕ ФоновоеЗаданиеПоЗагрузкеАктивно(КодУзла) И ВсеПринятыеПакетыЗапущеныНаЗагрузку Тогда
		
		СтруктураЗаписи = Новый Структура("Узел, ДатаИВремяПоследнейСинхронизации, СтатусСинхронизации", ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла), ТекущаяДата(), Перечисления.СтатусыСинхронизацииМП.СинхронизацияЗавершена);
		РегистрыСведений.ЖурналСинхронизацииМП.ЗаписатьИнформацию(СтруктураЗаписи);
		
		СтруктураОтвета.Вставить("ЗагрузкаНаСервереОкончена", Истина);
		
		// Отправляем пуш сообщения для остальныйх участников синхронизации
		Узел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
		Если Узел.ДобавленыНовыеДанные Тогда
			ПараметрыФоновогоЗадания = Новый Массив;
			ПараметрыФоновогоЗадания.Добавить(КодУзла);
			ФоновыеЗадания.Выполнить("СинхронизацияПушУведомленияМПУНФ.ОтправитьПушУведомление", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "Отправка пуш уведомлений");
		КонецЕсли;
		
	Иначе
		СтруктураОтвета.Вставить("ЗагрузкаНаСервереОкончена", Ложь);
		
		Если НЕ ВсеПринятыеПакетыЗапущеныНаЗагрузку Тогда
			ФоновыеЗадания.Выполнить("СинхронизацияЗагрузкаМП.ЗапускЗагрузки", , Новый УникальныйИдентификатор, "Загрузка пакета от " + КодУзла);
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаОтправки = СформироватьСтрокуОтправки(СтруктураОтвета);
	
	Ответ.УстановитьТелоИзСтроки(СтрокаОтправки);
	
	Возврат Ответ;
	
КонецФункции

Функция DeleteNewNumbersPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	ПараметрыФоновогоЗадания = Новый Массив;
	ПараметрыФоновогоЗадания.Добавить(СтруктураЗапроса);
	ФоновыеЗадания.Выполнить("СинхронизацияМПУНФ.ЗапуститьУдалениеНомеровВфоновомЗадании", ПараметрыФоновогоЗадания, Новый УникальныйИдентификатор, "Удаление записей из регистра сведений НомераСправочниковИДокументовДляИзмененияНаКлиентскомУзле");
	
	Возврат Ответ;
	
КонецФункции

Функция SendImagePost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	УникальныйИдентификатор = Новый УникальныйИдентификатор(Запрос.ПолучитьТелоКакСтроку());
	Ссылка = Справочники.ТоварыМП.ПолучитьСсылку(УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Картинка = ПолучитьКартинку(Ссылка);
		Если Картинка <> Неопределено Тогда
			Ответ.УстановитьТелоИзДвоичныхДанных(Картинка.Значение);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция GetListOfUsersGet(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	Запрос = Новый Запрос();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.ИдентификаторПользователяИБ,
	|	Пользователи.Наименование,
	|	Пользователи.Недействителен,
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Служебный
	|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойИД";
	
	Запрос.УстановитьПараметр("ПустойИД", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивПользователей = Новый Массив();
	
	Пока Выборка.Следующий() Цикл
		Профиль = РегистрыСведений.ПрофилиМобильныхПользователей.ПолучитьПрофильПользователя(Выборка.Ссылка);
		ВходВПрограммуРазрешен = Пользователи.ВходВПрограммуРазрешен(Выборка.ИдентификаторПользователяИБ);
		МассивПользователей.Добавить(
		Новый Структура("Наименование, ИдентификаторПользователяИБ, Недействителен, ВходВПрограммуРазрешен, Профиль",
		Выборка.Наименование,
		Выборка.ИдентификаторПользователяИБ,
		Выборка.Недействителен,
		ВходВПрограммуРазрешен,
		Перечисления.ПрофилиМобильногоПриложения.ПолучитьСтроковоеПредставление(Профиль))
		);
	КонецЦикла;
	
	СтрокаОтправки = СформироватьСтрокуОтправки(Новый Структура("МассивПользователей", МассивПользователей));
	
	Ответ.УстановитьТелоИзСтроки(СтрокаОтправки);
	
	Возврат Ответ;
	
КонецФункции

Функция AddUserPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	НачатьТранзакцию();
	
	НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
	НовыйПользователь.Наименование = СтруктураЗапроса.ПочтаПользователя;
	СтруктураАдресаЭП = ПолучитьСтруктуруАдресаЭлектроннойПочты(СтруктураЗапроса.ПочтаПользователя);
	ОбновитьАдресЭлектроннойПочты(НовыйПользователь, СтруктураЗапроса.ПочтаПользователя, СтруктураАдресаЭП);
	
	ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
	ОписаниеПользователяИБ.Имя = СтруктураЗапроса.ПочтаПользователя;
	ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
	ОписаниеПользователяИБ.АутентификацияOpenID = Истина;
	ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
	ОписаниеПользователяИБ.Вставить("Действие", "Записать");
	ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", Истина);
	ОписаниеПользователяИБ.Пароль = "" + Новый УникальныйИдентификатор + "qQ";
	
	НовыйПользователь.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	НовыйПользователь.ДополнительныеСвойства.Вставить("ПарольПользователяСервиса", СтруктураЗапроса.ПарольПользователяСервиса);
	НовыйПользователь.ДополнительныеСвойства.Вставить("СинхронизироватьССервисом", Истина);
	НовыйПользователь.Записать();
	
	ГруппаДоступа = Справочники.ГруппыДоступа.Администраторы.ПолучитьОбъект();
	ПользовательГруппы = ГруппаДоступа.Пользователи.Добавить();
	ПользовательГруппы.Пользователь = НовыйПользователь.Ссылка;
	ГруппаДоступа.ДополнительныеСвойства.Вставить("ПарольПользователяСервиса", СтруктураЗапроса.ПарольПользователяСервиса);
	ГруппаДоступа.Записать();
	
	РегистрыСведений.ПрофилиМобильныхПользователей.НазначитьПрофильПользователю(НовыйПользователь.Ссылка, СтруктураЗапроса.ПрофильПользователя);
	
	ЗафиксироватьТранзакцию();
	
	Ответ.УстановитьТелоИзСтроки(НСтр("ru='Пользователю успешно отправлено приглашение на электронный адрес.'"));
	
	Возврат Ответ;
	
КонецФункции

Функция UpdateUserDetailsPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	НачатьТранзакцию();
	
	Пользователь = Справочники.Пользователи.НайтиПоНаименованию(СтруктураЗапроса.ПочтаПользователя, Истина);
	
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Ответ.УстановитьТелоИзСтроки(НСтр("ru='Пользователь не найден.'"));
		Возврат Ответ;
	КонецЕсли;
	
	ОписаниеПользователяИБ = Неопределено;
	
	Пользователи.СвойстваПользователяИБ(Пользователь.ИдентификаторПользователяИБ);
	
	Если СтруктураЗапроса.ВходРазрешен Тогда
		ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
		ОписаниеПользователяИБ.АутентификацияOpenID = Истина;
	Иначе
		ОписаниеПользователяИБ.АутентификацияСтандартная = Ложь;
		ОписаниеПользователяИБ.АутентификацияOpenID = Ложь;
	КонецЕсли;
	
	ОписаниеПользователяИБ.Вставить("Действие", "Записать");
	ПользовательОбъект = Пользователь.ПолучитьОбъект();
	ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	ПользовательОбъект.ДополнительныеСвойства.Вставить("ПарольПользователяСервиса", СтруктураЗапроса.ПарольПользователяСервиса);
	ПользовательОбъект.ДополнительныеСвойства.Вставить("СинхронизироватьССервисом", Истина);
	ПользовательОбъект.Записать();
	
	РегистрыСведений.ПрофилиМобильныхПользователей.НазначитьПрофильПользователю(Пользователь, СтруктураЗапроса.ПрофильПользователя);
	
	ЗафиксироватьТранзакцию();
	
	Ответ.УстановитьТелоИзСтроки(НСтр("ru='Параметры пользователя успешно изменены.'"));
	
	Возврат Ответ;
	
КонецФункции

Функция GetPrimaryDataPost(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	
	МассивСПервичнымиДанными = Новый Массив;
	
	Выборка = Справочники.СтавкиНДСМП.Выбрать();
	МассивСтавкиНДСМП = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Структура = Новый Структура("УникальныйИдентификатор, Объект", Выборка.Ссылка.УникальныйИдентификатор(), Выборка.Ссылка.ПолучитьОбъект());
		МассивСПервичнымиДанными.Добавить(Структура);
	КонецЦикла;
	
	Выборка = Справочники.СтатьиМП.Выбрать();
	МассивСтатьиМП = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Структура = Новый Структура("УникальныйИдентификатор, Объект", Выборка.Ссылка.УникальныйИдентификатор(), Выборка.Ссылка.ПолучитьОбъект());
		МассивСПервичнымиДанными.Добавить(Структура);
	КонецЦикла;
	
	Выборка = Справочники.СтруктурныеЕдиницыМП.Выбрать();
	МассивСтруктурныеЕдиницыМП = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Структура = Новый Структура("УникальныйИдентификатор, Объект", Выборка.Ссылка.УникальныйИдентификатор(), Выборка.Ссылка.ПолучитьОбъект());
		МассивСПервичнымиДанными.Добавить(Структура);
	КонецЦикла;
	
	Выборка = Справочники.КассыККММП.Выбрать();
	МассивКассыККММП = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Структура = Новый Структура("УникальныйИдентификатор, Объект", Выборка.Ссылка.УникальныйИдентификатор(), Выборка.Ссылка.ПолучитьОбъект());
		МассивСПервичнымиДанными.Добавить(Структура);
	КонецЦикла;
	
	КоличествоПользователей = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СинхронизацияМП.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.СинхронизацияМП КАК СинхронизацияМП";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КоличествоПользователей = КоличествоПользователей + 1;
	КонецЦикла;
	
	СтруктураОтвета = Новый Структура("МассивСПервичнымиДанными, КоличествоПользователей", МассивСПервичнымиДанными, КоличествоПользователей);
	
	СтрокаОтправки = СформироватьСтрокуОтправки(СтруктураОтвета);
	
	Ответ.УстановитьТелоИзСтроки(СтрокаОтправки);
	
	Возврат Ответ;
	
КонецФункции

Функция GetSubscriberIDPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	СтруктураЗапроса = ПолучитьСтруктуруЗапроса(Запрос.ПолучитьТелоКакСтроку());
	
	КлиентскийУзел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(СтруктураЗапроса.КодУзла);
	
	КлиентскийУзелОбъект = КлиентскийУзел.ПолучитьОбъект();
	КлиентскийУзелОбъект.ИдентификаторПодписчикаДоставляемыхУведомлений = Новый ХранилищеЗначения(СтруктураЗапроса.ИдентификаторПодписчикаУведомлений);
	КлиентскийУзелОбъект.Записать();
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруЗапроса(СтрокаЗапроса)
	
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(СтрокаЗапроса);
	СтруктураЗапроса = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
	
	Возврат СтруктураЗапроса
	
КонецФункции

Функция СформироватьСтрокуОтправки(СтруктураОтвета)
	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СтруктураОтвета);
	СтрокаОтправки = ЗаписьXML.Закрыть();
	
	Возврат СтрокаОтправки
	
КонецФункции

Процедура ПроверитьНаличиеЦентральногоУзла()
	
	ЦентральныйУзел = ПланыОбмена.СинхронизацияМП.ЭтотУзел();
	Если НЕ ЗначениеЗаполнено(ЦентральныйУзел.Код) Тогда
		ОбъектУзла = ЦентральныйУзел.ПолучитьОбъект();
		ОбъектУзла.Код = "001";
		ОбъектУзла.Наименование = "Центральный";
		ОбъектУзла.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьНаличиеКлиентскогоУзла(КодУзла, НаименованиеУзла)
	
	КлиентскийУзел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодУзла);
	Если КлиентскийУзел.Пустая() Тогда
		СоздатьКлиентскийУзел(КодУзла, НаименованиеУзла);
	КонецЕсли;
	
КонецФункции

Процедура СоздатьКлиентскийУзел(КодУзла, НаименованиеУзла)
	
	Перем КлиентскийУзел, КоличесвтоМобильныхУстройств, НаименованиеСуществующегоУзла, НаименованиеУзлаНаКлиентскомУзле, НовыйУзел, СуществующийУзел;
	
	НовыйУзел = ПланыОбмена.СинхронизацияМП.СоздатьУзел();
	НовыйУзел.Код = Новый УникальныйИдентификатор;
	КодУзла = НовыйУзел.Код;
	КоличесвтоМобильныхУстройств = 1;
	СуществующийУзел = ПланыОбмена.СинхронизацияМП.НайтиПоНаименованию(НаименованиеУзла);
	Если НЕ СуществующийУзел.Пустая() Тогда
		НаименованиеУзлаНаКлиентскомУзле = НаименованиеУзла;
		НаименованиеСуществующегоУзла = СуществующийУзел.Наименование;
		Пока НаименованиеУзла = НаименованиеСуществующегоУзла Цикл
			НаименованиеУзла = НаименованиеУзлаНаКлиентскомУзле + "(" + КоличесвтоМобильныхУстройств + ")";
			КоличесвтоМобильныхУстройств = КоличесвтоМобильныхУстройств + 1;
			СуществующийУзел = ПланыОбмена.СинхронизацияМП.НайтиПоНаименованию(НаименованиеУзла);
			НаименованиеСуществующегоУзла = СуществующийУзел.Наименование;
		КонецЦикла;
	КонецЕсли;
	НовыйУзел.Наименование = НаименованиеУзла;
	НовыйУзел.Записать();
	КлиентскийУзел = НовыйУзел.Ссылка;
	ПланыОбмена.ЗарегистрироватьИзменения(КлиентскийУзел);

КонецПроцедуры

Функция ПолучитьИнформациюОВерсиях(ВерсияСервера,ВерсияМобильногоПриложения)
	
	ИнформацияОВерсиях = Перечисления.СтатусыВерсийМП.ВерсииОдинаковые;
	Если ВерсияСервера <> ВерсияМобильногоПриложения Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СхемыКонфигурацийМП.Версия КАК Версия,
		|	СхемыКонфигурацийМП.Схема КАК Схема
		|ИЗ
		|	РегистрСведений.СхемыКонфигурацийМП КАК СхемыКонфигурацийМП
		|ГДЕ
		|	СхемыКонфигурацийМП.Версия = &Версия";
		
		Запрос.УстановитьПараметр("Версия", ВерсияМобильногоПриложения);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			Схема = ВыборкаДетальныеЗаписи.Схема;
		КонецЕсли;
		
		Если Схема = Неопределено Тогда
			ИнформацияОВерсиях = Перечисления.СтатусыВерсийМП.СерверуНужнаСхемаКлиента;
		Иначе
			ИнформацияОВерсиях = Перечисления.СтатусыВерсийМП.ВерсииРазные;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИнформацияОВерсиях
КонецФункции

Процедура ЗапуститьВыгрузкуВФоновомЗадании(КодКлиентскогоУзла)
	
	
	ПараметрыФоновогоЗадания = Новый Массив;
	ПараметрыФоновогоЗадания.Добавить(КодКлиентскогоУзла);
	УникальныйИдентификатор = Новый УникальныйИдентификатор;
	ФоновыеЗадания.Выполнить("СинхронизацияВыгрузкаМП.ЗапускВыгрузки",ПараметрыФоновогоЗадания, УникальныйИдентификатор, "Формирование пакетов для " + КодКлиентскогоУзла);
	
	СтруктураЗаписи = Новый Структура("Узел, ИдентификаторФоновогоЗаданияНаСервере", ПланыОбмена.СинхронизацияМП.НайтиПоКоду(КодКлиентскогоУзла), УникальныйИдентификатор);
	РегистрыСведений.ЖурналСинхронизацииМП.ЗаписатьИнформацию(СтруктураЗаписи);
	
КонецПроцедуры

Процедура ОбработатьЗапросКлиента(СтруктураЗапроса)
	
	КлиентскийУзел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(СтруктураЗапроса.КодКлиентскогоУзла);
	
	ФормированиеПакетовНаКлиенте = РегистрыСведений.ЖурналСинхронизацииМП.ПолучитьФормированиеПакетовНаКлиенте(СтруктураЗапроса.КодКлиентскогоУзла);
	
	Если СтруктураЗапроса.СообщениеОбмена = Перечисления.СтатусыФормированияПакетовМП.Завершено И ФормированиеПакетовНаКлиенте <> Перечисления.СтатусыФормированияПакетовМП.Завершено Тогда
		
		СтруктураЗаписи = Новый Структура("ФормированиеПакетовНаКлиенте, Узел", Перечисления.СтатусыФормированияПакетовМП.Завершено, КлиентскийУзел);
		РегистрыСведений.ЖурналСинхронизацииМП.ЗаписатьИнформацию(СтруктураЗаписи);
		
	ИначеЕсли ТипЗнч(СтруктураЗапроса.СообщениеОбмена) = Тип("ХранилищеЗначения") Тогда
		
		ЦентральныйУзел = ПланыОбмена.СинхронизацияМП.ЭтотУзел().ПолучитьОбъект();
		
		НомерСообщенияОбмена = РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.ПолучитьНомерСообщения(ЦентральныйУзел.НомерПринятого);
		
		РегистрыСведений.ПринятыеСообщенияДляЗагрузкиМП.ДобавитьСообщение(НомерСообщенияОбмена, СтруктураЗапроса.СообщениеОбмена, СтруктураЗапроса.ВерсияМобильногоПриложения, СтруктураЗапроса.КодКлиентскогоУзла);
		
		ФоновыеЗадания.Выполнить("СинхронизацияЗагрузкаМП.ЗапускЗагрузки", , Новый УникальныйИдентификатор, "Загрузка пакета от " + СтруктураЗапроса.КодКлиентскогоУзла);
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьОтветДляКлиента(СтруктураЗапроса)
	
	ФормированиеПакетовНаСервере = РегистрыСведений.ЖурналСинхронизацииМП.ПолучитьФормированиеПакетовНаСервере(СтруктураЗапроса.КодКлиентскогоУзла);
	ФормированиеПакетовНаКлиенте = РегистрыСведений.ЖурналСинхронизацииМП.ПолучитьФормированиеПакетовНаКлиенте(СтруктураЗапроса.КодКлиентскогоУзла);
	
	ВерсияСообщенияДляОтправки = Неопределено;
	СообщениеОбменаДляОтправки = Неопределено;
	НомерСообщения = Неопределено;
	
	РегистрыСведений.СформированныеСообщенияДляОтправкиМП.ПолучитьСообщение(СтруктураЗапроса.КодКлиентскогоУзла, ВерсияСообщенияДляОтправки, СообщениеОбменаДляОтправки, НомерСообщения);
	
	СтруктураОтвета = Новый Структура;
	
	Если СообщениеОбменаДляОтправки <> Неопределено Тогда
		
		СтруктураОтвета.Вставить("Версия", ВерсияСообщенияДляОтправки);
		СтруктураОтвета.Вставить("СообщениеОбмена", СообщениеОбменаДляОтправки);
		СтруктураОтвета.Вставить("НомерСообщения", НомерСообщения);
		
	ИначеЕсли СообщениеОбменаДляОтправки = Неопределено И ФормированиеПакетовНаСервере = Перечисления.СтатусыФормированияПакетовМП.Запущено Тогда
		
		СтатусФоновогоЗаданияНаСервере = ПроверитьРаботуФоновогоЗаданияПоВыгрузкеПакетов(СтруктураЗапроса.КодКлиентскогоУзла);
		ФормированиеПакетовНаСервере = РегистрыСведений.ЖурналСинхронизацииМП.ПолучитьФормированиеПакетовНаСервере(СтруктураЗапроса.КодКлиентскогоУзла);
		
		Если СтатусФоновогоЗаданияНаСервере = Ложь И ФормированиеПакетовНаСервере = Перечисления.СтатусыФормированияПакетовМП.Запущено Тогда
			СтруктураОтвета.Вставить("СообщениеОбмена", Перечисления.СтатусыФормированияПакетовМП.НеЗавершено);
		Иначе
			СтруктураОтвета.Вставить("СообщениеОбмена", Перечисления.СтатусыФормированияПакетовМП.ВПроцессе);
		КонецЕсли;
		
	ИначеЕсли СообщениеОбменаДляОтправки = Неопределено И ФормированиеПакетовНаСервере = Перечисления.СтатусыФормированияПакетовМП.Завершено Тогда
		
		// Здесь делать контрольную загрузку  НОВОЕ!!!!!!!!!!!! ПРОВЕРИТЬ
		Если НЕ ВсеПринятыеПакетыЗапущеныНаЗагрузку(СтруктураЗапроса.КодКлиентскогоУзла) Тогда
			ФоновыеЗадания.Выполнить("СинхронизацияЗагрузкаМП.ЗапускЗагрузки", , Новый УникальныйИдентификатор, "Загрузка пакета от " + СтруктураЗапроса.КодКлиентскогоУзла);
		КонецЕсли;
		//
		
		СтруктураОтвета.Вставить("СообщениеОбмена", Перечисления.СтатусыФормированияПакетовМП.Завершено);
		
	КонецЕсли;
	
	СтрокаОтправки = СформироватьСтрокуОтправки(СтруктураОтвета);
	
	Если ФормированиеПакетовНаСервере = Перечисления.СтатусыФормированияПакетовМП.Завершено И ФормированиеПакетовНаКлиенте = Перечисления.СтатусыФормированияПакетовМП.Завершено Тогда
		КлиентскийУзел = ПланыОбмена.СинхронизацияМП.НайтиПоКоду(СтруктураЗапроса.КодКлиентскогоУзла);
		СтруктураЗаписи = Новый Структура("Узел, ДатаИВремяПоследнейСинхронизации, СтатусСинхронизации", КлиентскийУзел, ТекущаяДата(), Перечисления.СтатусыСинхронизацииМП.ПолучениеНомеров);
		РегистрыСведений.ЖурналСинхронизацииМП.ЗаписатьИнформацию(СтруктураЗаписи);
	КонецЕсли;
	
	Возврат СтрокаОтправки
	
КонецФункции

Функция ПроверитьРаботуФоновогоЗаданияПоВыгрузкеПакетов(КодКлиентскогоУзла)
	
	ПросмотрТекЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ, Состояние", РегистрыСведений.ЖурналСинхронизацииМП.ПолучитьИдентификаторФоновогоЗадания(КодКлиентскогоУзла), СостояниеФоновогоЗадания.Активно));
	
	ЗаданиеВыполняется = Ложь;
	
	Для каждого ТекЗадание Из ПросмотрТекЗадания Цикл
		ЗаданиеВыполняется = Истина;
	КонецЦикла;
	
	Возврат ЗаданиеВыполняется;

КонецФункции

Функция ПолучитьКартинку(СсылкаНаОбъект)
	
	ДвоичныеДанныеФайла = СсылкаНаОбъект.Картинка.Получить();
	СериализиаторXDTO = Новый СериализаторXDTO(ФабрикаXDTO);
	
	Попытка
		Если ДвоичныеДанныеФайла = Неопределено Тогда
			КартинкаXDTO = Неопределено;
		Иначе
			КартинкаXDTO = СериализиаторXDTO.ЗаписатьXDTO(ДвоичныеДанныеФайла);
		КонецЕсли;
	Исключение
		КартинкаXDTO = Неопределено;
	КонецПопытки;
	
	Возврат КартинкаXDTO;
	
КонецФункции

Процедура ОбновитьАдресЭлектроннойПочты(Знач ПользовательОбъект, Знач Адрес, Знач СтруктураАдресаЭП)
	
	ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователя;
	
	СтрокаТабличнойЧасти = ПользовательОбъект.КонтактнаяИнформация.Найти(ВидКИ, "Вид");
	Если СтруктураАдресаЭП = Неопределено Тогда
		Если СтрокаТабличнойЧасти <> Неопределено Тогда
			ПользовательОбъект.КонтактнаяИнформация.Удалить(СтрокаТабличнойЧасти);
		КонецЕсли;
	Иначе
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			СтрокаТабличнойЧасти = ПользовательОбъект.КонтактнаяИнформация.Добавить();
			СтрокаТабличнойЧасти.Вид = ВидКИ;
		КонецЕсли;
		СтрокаТабличнойЧасти.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		СтрокаТабличнойЧасти.Представление = Адрес;
		
		Если СтруктураАдресаЭП.Количество() > 0 Тогда
			СтрокаТабличнойЧасти.АдресЭП = СтруктураАдресаЭП[0].Адрес;
			
			Поз = СтрНайти(СтрокаТабличнойЧасти.АдресЭП, "@");
			Если Поз <> 0 Тогда
				СтрокаТабличнойЧасти.ДоменноеИмяСервера = Сред(СтрокаТабличнойЧасти.АдресЭП, Поз + 1);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСтруктуруАдресаЭлектроннойПочты(Знач АдресЭлектроннойПочты)
	
	Если ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		
		Попытка
			СтруктураАдресаЭП = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресЭлектроннойПочты);
		Исключение
			ШаблонСообщения = НСтр("ru = 'Указан некорректный адрес электронной почты: %1
				|Ошибка: %2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, АдресЭлектроннойПочты, ИнформацияОбОшибке().Описание);
			ВызватьИсключение(ТекстСообщения);
		КонецПопытки;
		
		Возврат СтруктураАдресаЭП;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ФоновоеЗаданиеПоЗагрузкеАктивно(КодКлиентскогоУзла)
	
	ЗаданиеВыполняется = Ложь;
	
	МассивЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Наименование, Состояние", "Загрузка пакета от " + КодКлиентскогоУзла, СостояниеФоновогоЗадания.Активно));
	
	Для каждого ТекЗадание Из МассивЗаданий Цикл
		ЗаданиеВыполняется = Истина;
	КонецЦикла;
	
	Возврат ЗаданиеВыполняется;
	
КонецФункции

Функция ВсеПринятыеПакетыЗапущеныНаЗагрузку(КодУзла)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПринятыеСообщенияДляЗагрузкиМП.НомерСообщения КАК НомерСообщения,
	|	ПринятыеСообщенияДляЗагрузкиМП.Версия КАК Версия,
	|	ПринятыеСообщенияДляЗагрузкиМП.КодУзла КАК КодУзла,
	|	ПринятыеСообщенияДляЗагрузкиМП.СообщениеОбмена КАК СообщениеОбмена
	|ИЗ
	|	РегистрСведений.ПринятыеСообщенияДляЗагрузкиМП КАК ПринятыеСообщенияДляЗагрузкиМП
	|ГДЕ
	|	ПринятыеСообщенияДляЗагрузкиМП.СообщениеОбрабатывается = &Ложь
	|	И ПринятыеСообщенияДляЗагрузкиМП.КодУзла = &КодУзла
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСообщения";
	
	Запрос.УстановитьПараметр("Ложь", Ложь);
	Запрос.УстановитьПараметр("КодУзла", КодУзла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

